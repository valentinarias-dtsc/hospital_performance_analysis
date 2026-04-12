-- ============================================
-- 01_schema.sql
-- Definición de tabla RAW
-- Proyecto: Hospital Performance Analysis
-- ============================================

DROP TABLE IF EXISTS hospital_performance_raw CASCADE;

CREATE TABLE hospital_performance_raw (

    hospital_id TEXT PRIMARY KEY,
    hospital_name TEXT,
    sector TEXT,
    city TEXT,
    province TEXT,
    hospital_type TEXT,

    year INT,

    total_beds INT,
    icu_beds INT,
    operation_theatres INT,

    emergency_department TEXT,
    diagnostic_labs TEXT,

    medical_equipment_score DOUBLE PRECISION,

    total_doctors INT,
    specialists INT,
    nurses INT,
    paramedical_staff INT,

    doctor_patient_ratio DOUBLE PRECISION,

    daily_outpatients INT,
    monthly_admissions INT,
    surgeries_per_month INT,

    average_length_of_stay DOUBLE PRECISION,

    emergency_cases INT,
    average_treatment_cost DOUBLE PRECISION,
    consultation_fee DOUBLE PRECISION,
    surgery_cost DOUBLE PRECISION,
    government_funding DOUBLE PRECISION,

    insurance_accepted TEXT,

    patient_satisfaction_score DOUBLE PRECISION,
    mortality_rate DOUBLE PRECISION,
    infection_rate DOUBLE PRECISION,
    readmission_rate DOUBLE PRECISION,

    waiting_time_minutes INT,
    
    distance_from_city_center DOUBLE PRECISION,
    ambulance_available TEXT,
    telemedicine_service TEXT,
    rural_patients_percentage DOUBLE PRECISION
);

-- Índices básicos
CREATE INDEX IF NOT EXISTS idx_hospital_city ON hospital_performance_raw(city);
CREATE INDEX IF NOT EXISTS idx_hospital_province ON hospital_performance_raw(province);