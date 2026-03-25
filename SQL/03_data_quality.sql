-- ============================================
-- 03_data_quality.sql
-- Data Quality Checks
-- Proyecto: Hospital Performance Analysis
-- ============================================

-- =========================
-- 1. Conteo total de filas
-- =========================
SELECT COUNT(*) AS total_rows
FROM hospital_performance_raw;


-- =========================
-- 2. Duplicados por clave primaria
-- =========================
-- Validación: hospital_id debería ser único
SELECT hospital_id, COUNT(*) AS occurrences
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
SELECT *
FROM hospital_performance_raw
WHERE 
    mortality_rate < 0 OR
    readmission_rate < 0 OR
    infection_rate < 0 OR
    average_treatment_cost < 0 OR
    waiting_time_minutes < 0 OR
    average_length_of_stay < 0;


-- =========================
-- 5. Validación de rangos lógicos (tasas)
-- =========================
SELECT *
FROM hospital_performance_raw
WHERE 
    mortality_rate > 100 OR
    readmission_rate > 100 OR
    infection_rate > 100;



-- =========================
-- 6. Consistencia estructural
-- =========================

-- ICU beds no debería superar total beds
SELECT *
FROM hospital_performance_raw
WHERE icu_beds > total_beds;

-- Staff inconsistente
SELECT *
FROM hospital_performance_raw
WHERE total_doctors <= 0 OR doctor_patient_ratio <= 0;


-- =========================
-- 7. Verificación básica de métricas
-- =========================
SELECT
    MIN(waiting_time_minutes) AS min_waiting,
    MAX(waiting_time_minutes) AS max_waiting,
    MIN(average_treatment_cost) AS min_cost,
    MAX(average_treatment_cost) AS max_cost
FROM hospital_performance_raw;


-- ============================================
-- Observaciones (completar manualmente)
-- ============================================

-- Ejemplos:
-- - No se detectaron valores NULL en columnas críticas
-- - Se identificaron X inconsistencias en relaciones de camas
-- - Se detectaron valores extremos en costos o tiempos de espera
