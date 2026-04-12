-- ============================================================
-- queries.sql
-- Exploration et validation des données brutes
-- Table source : industrial_sensor_data
-- ============================================================


-- Résumé global : nombre de lignes, machines et capteurs
SELECT 
    COUNT(*)                    AS total_rows,
    COUNT(DISTINCT asset_id)    AS nb_machines,
    COUNT(DISTINCT sensor_type) AS nb_capteurs
FROM industrial_sensor_data;


-- Moyenne des valeurs par machine et capteur
SELECT 
    asset_id,
    machine_name,
    sensor_type,
    AVG(value) AS avg_value
FROM industrial_sensor_data
GROUP BY asset_id, machine_name, sensor_type
ORDER BY asset_id;


-- Détection d'anomalies par Z-Score (|Z| > 3)
-- Cohérent avec la détection Python du pipeline ETL
WITH stats AS (
    SELECT 
        machine_name,
        sensor_type,
        AVG(value)   AS avg_value,
        STDEV(value) AS std_value
    FROM industrial_sensor_data
    GROUP BY machine_name, sensor_type
),
z_scores AS (
    SELECT 
        m.machine_name,
        m.sensor_type,
        m.value,
        s.avg_value,
        s.std_value,
        (m.value - s.avg_value) / NULLIF(s.std_value, 0) AS z_score
    FROM industrial_sensor_data m
    JOIN stats s
        ON m.machine_name = s.machine_name
       AND m.sensor_type  = s.sensor_type
)
SELECT *
FROM z_scores
WHERE ABS(z_score) > 3
ORDER BY ABS(z_score) DESC;