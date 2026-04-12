-- ============================================================
-- check_bi.sql
-- Contrôle qualité post-chargement des données enrichies
-- Table source : industrial_sensor_bi_full
-- ============================================================


-- Vérification des 10 dernières entrées chargées
SELECT TOP 10 *
FROM industrial_sensor_bi_full
ORDER BY timestamp DESC;


-- Statistiques descriptives par machine et capteur
-- Permet de valider la cohérence des valeurs après ETL
SELECT 
    machine_name,
    sensor_type,
    AVG(value) AS mean,
    MIN(value) AS min,
    MAX(value) AS max
FROM industrial_sensor_bi_full
GROUP BY machine_name, sensor_type
ORDER BY machine_name, sensor_type;