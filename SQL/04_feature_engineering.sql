-- ============================================
-- 04_feature_engineering.sql
-- Data Cleaning & Feature Engineering
-- Proyecto: Hospital Performance Analysis
-- ============================================

-- =========================
-- 1. Crear tabla CLEAN
-- =========================

DROP TABLE IF EXISTS hospital_performance_clean;

CREATE TABLE hospital_performance_clean AS
SELECT
    *,
    
    -- =========================
    -- 2. Flags de calidad de datos
    -- =========================
    
    -- Error estructural: ICU > total beds
    CASE 
        WHEN icu_beds > total_beds THEN 1
        ELSE 0
    END AS icu_inconsistency_flag,
    
    -- Ratio alto pero posible
    CASE 
        WHEN icu_beds / NULLIF(total_beds, 0) > 0.3 THEN 1
        ELSE 0
    END AS icu_high_ratio_flag,
    
    
    -- =========================
    -- 3. Features derivadas
    -- =========================
    
    -- Ratio ICU / total beds
    icu_beds / NULLIF(total_beds, 0) AS icu_bed_ratio,
    
    -- Ratio de médicos sobre pacientes
    total_doctors / NULLIF(daily_outpatients, 0) AS doctor_per_patient_ratio,
    
    -- Intensidad operativa (uso de infraestructura)
    surgeries_per_month / NULLIF(operation_theatres, 0) AS surgeries_per_theatre,
    
    -- Carga hospitalaria
    daily_outpatients + monthly_admissions / 30.0 AS estimated_daily_load,
    
    -- Staff total
    (total_doctors + nurses + paramedical_staff) AS total_staff,
    
    -- Ratio staff / pacientes
    (total_doctors + nurses + paramedical_staff) 
        / NULLIF(daily_outpatients, 0) AS staff_per_patient_ratio

FROM hospital_performance_raw;