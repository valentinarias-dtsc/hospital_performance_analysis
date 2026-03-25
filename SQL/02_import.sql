-- ============================================
-- 02_import.sql
-- Carga de datos desde CSV
-- Proyecto: Hospital Performance Analysis
-- ============================================

TRUNCATE TABLE hospital_performance_raw;

COPY hospital_performance_raw
FROM 'C:/Github/hospital_performance_analysis/data/raw/pakistan_healthcare.csv'
CSV HEADER;