-- ============================================
-- 05_hpi_calculation.sql
-- Hospital Performance Index (HPI)
-- Proyecto: Hospital Performance Analysis
-- ============================================

-- =========================
-- 1. Crear tabla final
-- =========================

DROP TABLE IF EXISTS hospital_performance_hpi;

CREATE TABLE hospital_performance_hpi AS

-- =========================
-- 2. Pipeline HPI
-- =========================

WITH base AS (
    SELECT *
    FROM hospital_performance_clean
    
    -- Opcional: excluir inconsistencias graves
    WHERE icu_inconsistency_flag = 0
),

-- =========================
-- 3. Estadísticos globales
-- =========================
stats AS (
    SELECT
        MIN(mortality_rate) AS min_mort,
        MAX(mortality_rate) AS max_mort,
        
        MIN(readmission_rate) AS min_readm,
        MAX(readmission_rate) AS max_readm,
        
        MIN(infection_rate) AS min_inf,
        MAX(infection_rate) AS max_inf,
        
        MIN(patient_satisfaction_score) AS min_sat,
        MAX(patient_satisfaction_score) AS max_sat,
        
        MIN(waiting_time_minutes) AS min_wait,
        MAX(waiting_time_minutes) AS max_wait,
        
        MIN(average_length_of_stay) AS min_los,
        MAX(average_length_of_stay) AS max_los,
        
        MIN(average_treatment_cost) AS min_cost,
        MAX(average_treatment_cost) AS max_cost
        
    FROM base
),

-- =========================
-- 4. Normalización
-- =========================
normalized AS (
    SELECT
        b.*,
        
        -- Calidad
        (mortality_rate - s.min_mort) / NULLIF(s.max_mort - s.min_mort, 0) AS mortality_norm,
        (readmission_rate - s.min_readm) / NULLIF(s.max_readm - s.min_readm, 0) AS readmission_norm,
        (infection_rate - s.min_inf) / NULLIF(s.max_inf - s.min_inf, 0) AS infection_norm,
        (patient_satisfaction_score - s.min_sat) / NULLIF(s.max_sat - s.min_sat, 0) AS satisfaction_norm,
        
        -- Eficiencia
        (waiting_time_minutes - s.min_wait) / NULLIF(s.max_wait - s.min_wait, 0) AS waiting_norm,
        (average_length_of_stay - s.min_los) / NULLIF(s.max_los - s.min_los, 0) AS los_norm,
        
        -- Costos
        (average_treatment_cost - s.min_cost) / NULLIF(s.max_cost - s.min_cost, 0) AS cost_norm
        
    FROM base b
    CROSS JOIN stats s
),

-- =========================
-- 5. Inversión de métricas
-- =========================
transformed AS (
    SELECT
        *,
        
        -- Calidad
        1 - mortality_norm AS mortality_inv,
        1 - readmission_norm AS readmission_inv,
        1 - infection_norm AS infection_inv,
        satisfaction_norm AS satisfaction_final,
        
        -- Eficiencia
        1 - waiting_norm AS waiting_inv,
        1 - los_norm AS los_inv,
        
        -- Costos
        1 - cost_norm AS cost_inv
        
    FROM normalized
),

-- =========================
-- 6. Subíndices
-- =========================
subindex AS (
    SELECT
        *,
        
        -- Calidad
        (mortality_inv + readmission_inv + infection_inv + satisfaction_final) / 4 AS quality_score,
        
        -- Eficiencia
        (waiting_inv + los_inv) / 2 AS efficiency_score,
        
        -- Costos
        cost_inv AS cost_score
        
    FROM transformed
)

-- =========================
-- 7. HPI final
-- =========================
SELECT
    hospital_id,
    hospital_name,
    city,
    province,
    
    ROUND(quality_score::numeric, 3) AS quality_score,
    ROUND(efficiency_score::numeric, 3) AS efficiency_score,
    ROUND(cost_score::numeric, 3) AS cost_score,
    
    ROUND((
        0.5 * quality_score +
        0.3 * efficiency_score +
        0.2 * cost_score
    )::numeric, 3) AS hpi,

    -- Segmentación
    CASE 
        WHEN (
            0.5 * quality_score +
            0.3 * efficiency_score +
            0.2 * cost_score
        ) >= 0.75 THEN 'High Performance'
        
        WHEN (
            0.5 * quality_score +
            0.3 * efficiency_score +
            0.2 * cost_score
        ) >= 0.5 THEN 'Medium Performance'
        
        ELSE 'Low Performance'
    END AS performance_category

FROM subindex;


-- ============================================
-- Export HPI dataset to CSV
-- ============================================

COPY hospital_performance_hpi
TO 'C:/Github/hospital_performance_analysis/data/hospital_performance_hpi.csv'
CSV HEADER;