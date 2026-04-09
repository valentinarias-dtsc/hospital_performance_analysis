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
    
    
    -- =========================
    -- 3. Features derivadas
    -- =========================
    
    -- Ratio ICU / total beds
    icu_beds::NUMERIC / NULLIF(total_beds, 0) AS icu_bed_ratio,
    
    -- Ratio de médicos sobre pacientes
    total_doctors::NUMERIC / NULLIF(estimated_daily_load, 0) AS doctor_per_patient_ratio,
    
    -- Intensidad operativa (uso de infraestructura)
    surgeries_per_month::NUMERIC / NULLIF(operation_theatres, 0) AS surgeries_per_theatre,
    
    -- Staff total
    (total_doctors + nurses + paramedical_staff)::NUMERIC AS total_staff,
    
    -- Ratio staff / pacientes
    (total_doctors + nurses + paramedical_staff)::NUMERIC 
        / NULLIF(estimated_daily_load, 0) AS staff_per_patient_ratio

FROM (SELECT 
        *, 
        daily_outpatients::NUMERIC + monthly_admissions::NUMERIC / 30.0 AS estimated_daily_load
        FROM hospital_performance_raw) AS subquery;