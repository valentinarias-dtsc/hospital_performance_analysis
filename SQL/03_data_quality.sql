-- ============================================
-- 03_data_quality.sql
-- Data Quality Checks
-- Proyecto: Hospital Performance Analysis
-- ============================================

-- =========================
-- 1. Conteo total de filas
-- =========================
SELECT COUNT(*) AS filas_totales
FROM hospital_performance_raw;


-- =========================
-- 2. Duplicados por clave primaria
-- =========================
-- Validación: hospital_id debería ser único
SELECT hospital_id, COUNT(*) AS ids_duplicados
FROM hospital_performance_raw
GROUP BY hospital_id
HAVING COUNT(*) > 1;


-- =========================
-- 3. Verificación de NULLs (todas las columnas)
-- =========================
SELECT
    COUNT(*) FILTER (WHERE hospital_id IS NULL) AS hospital_id_nulls,
    COUNT(*) FILTER (WHERE hospital_name IS NULL) AS hospital_name_nulls,
    COUNT(*) FILTER (WHERE sector IS NULL) AS sector_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE province IS NULL) AS province_nulls,
    COUNT(*) FILTER (WHERE hospital_type IS NULL) AS hospital_type_nulls,
    COUNT(*) FILTER (WHERE year IS NULL) AS year_nulls,

    COUNT(*) FILTER (WHERE total_beds IS NULL) AS total_beds_nulls,
    COUNT(*) FILTER (WHERE icu_beds IS NULL) AS icu_beds_nulls,
    COUNT(*) FILTER (WHERE operation_theatres IS NULL) AS operation_theatres_nulls,
    COUNT(*) FILTER (WHERE emergency_department IS NULL) AS emergency_department_nulls,
    COUNT(*) FILTER (WHERE diagnostic_labs IS NULL) AS diagnostic_labs_nulls,

    COUNT(*) FILTER (WHERE medical_equipment_score IS NULL) AS medical_equipment_score_nulls,

    COUNT(*) FILTER (WHERE total_doctors IS NULL) AS total_doctors_nulls,
    COUNT(*) FILTER (WHERE specialists IS NULL) AS specialists_nulls,
    COUNT(*) FILTER (WHERE nurses IS NULL) AS nurses_nulls,
    COUNT(*) FILTER (WHERE paramedical_staff IS NULL) AS paramedical_staff_nulls,

    COUNT(*) FILTER (WHERE doctor_patient_ratio IS NULL) AS doctor_patient_ratio_nulls,

    COUNT(*) FILTER (WHERE daily_outpatients IS NULL) AS daily_outpatients_nulls,
    COUNT(*) FILTER (WHERE monthly_admissions IS NULL) AS monthly_admissions_nulls,
    COUNT(*) FILTER (WHERE surgeries_per_month IS NULL) AS surgeries_per_month_nulls,
    COUNT(*) FILTER (WHERE emergency_cases IS NULL) AS emergency_cases_nulls,

    COUNT(*) FILTER (WHERE average_length_of_stay IS NULL) AS average_length_of_stay_nulls,
    COUNT(*) FILTER (WHERE waiting_time_minutes IS NULL) AS waiting_time_minutes_nulls,

    COUNT(*) FILTER (WHERE average_treatment_cost IS NULL) AS average_treatment_cost_nulls,
    COUNT(*) FILTER (WHERE consultation_fee IS NULL) AS consultation_fee_nulls,
    COUNT(*) FILTER (WHERE surgery_cost IS NULL) AS surgery_cost_nulls,
    COUNT(*) FILTER (WHERE government_funding IS NULL) AS government_funding_nulls,

    COUNT(*) FILTER (WHERE insurance_accepted IS NULL) AS insurance_accepted_nulls,

    COUNT(*) FILTER (WHERE patient_satisfaction_score IS NULL) AS patient_satisfaction_score_nulls,
    COUNT(*) FILTER (WHERE mortality_rate IS NULL) AS mortality_rate_nulls,
    COUNT(*) FILTER (WHERE infection_rate IS NULL) AS infection_rate_nulls,
    COUNT(*) FILTER (WHERE readmission_rate IS NULL) AS readmission_rate_nulls,

    COUNT(*) FILTER (WHERE distance_from_city_center IS NULL) AS distance_from_city_center_nulls,
    COUNT(*) FILTER (WHERE ambulance_available IS NULL) AS ambulance_available_nulls,
    COUNT(*) FILTER (WHERE telemedicine_service IS NULL) AS telemedicine_service_nulls,

    COUNT(*) FILTER (WHERE rural_patients_percentage IS NULL) AS rural_patients_percentage_nulls

FROM hospital_performance_raw;


-- =========================
-- 4. Validación de valores negativos
-- =========================
SELECT COUNT(*) AS datos_con_tasas_negativas
FROM hospital_performance_raw
WHERE 
    mortality_rate < 0 OR
    readmission_rate < 0 OR
    infection_rate < 0 OR
    average_treatment_cost < 0 OR
    waiting_time_minutes < 0 OR
    average_length_of_stay < 0 OR 
    doctor_patient_ratio <= 0;


-- =========================
-- 5. Validación de rangos lógicos (tasas)
-- =========================
SELECT COUNT(*) AS datos_con_tasas_encima_de_100
FROM hospital_performance_raw
WHERE 
    mortality_rate > 100 OR
    readmission_rate > 100 OR
    infection_rate > 100;


-- =========================
-- 6. Consistencia estructural
-- =========================

-- ICU beds no debería superar total beds
SELECT COUNT(*) AS datos_con_camas_inconsistentes
FROM hospital_performance_raw
WHERE icu_beds > total_beds;

-- Staff inconsistente
SELECT COUNT(*) AS datos_con_cantidades_negativas
FROM hospital_performance_raw
WHERE total_doctors <= 0 OR
      specialists < 0 OR
      nurses < 0 OR
      paramedical_staff < 0;


-- =========================
-- 7. Análisis de proporción de camas ICU
-- =========================
SELECT
    MIN((icu_beds::FLOAT / total_beds) * 100) AS icu_pct_minimo,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY (icu_beds::FLOAT / total_beds) * 100) AS icu_pct_q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY (icu_beds::FLOAT / total_beds) * 100) AS icu_pct_mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY (icu_beds::FLOAT / total_beds) * 100) AS icu_pct_q3,
    MAX((icu_beds::FLOAT / total_beds) * 100) AS icu_pct_maximo
FROM hospital_performance_raw
WHERE total_beds > 0;


-- ============================================
-- Observaciones
-- ============================================

-- - No existen duplicados
-- - No se detectaron valores NULL en ninguna columna
-- - No se detectaron valores inconsistentes en tasas, radios, ni cantidades
-- - Se identificaron 226 inconsistencias en relaciones de camas de terapia intensiva 
--   sobre el total. Esta cantidad representaría cerca del 4% del dataset.
-- - Profundizando el análisis, se logró identificar que cerca del 20-25% de los datos 
--   contienen valores atípicos en los porcentajes de camas de terapia intensiva 
--   valores normales en hospitales del mundo van desde un 5% hasta un 20% de este tipo de camas, en relación al total.