-- ============================================
-- 06_final_table.sql
-- Final table, ready for analysis
-- Proyecto: Hospital Performance Analysis
-- ============================================

-- =========================
-- 1. Crear tabla final
-- =========================

DROP VIEW IF EXISTS hospital_performance_final CASCADE;

CREATE VIEW hospital_performance_final AS

SELECT 
    b.*,
    s.quality_score,
    s.efficiency_score,
    s.cost_score,
    s.hpi

FROM hospital_performance_clean b
JOIN hospital_performance_hpi AS s USING(hospital_id);