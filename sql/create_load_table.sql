CREATE DATABASE INDUSTRIAL_DATA;
GO
/* 
créer la table industrial_sensor_data et chargement de données dans cette table
*/
USE INDUSTRIAL_DATA;
GO

DROP TABLE IF EXISTS industrial_sensor_data;
CREATE TABLE industrial_sensor_data (
    id INT,
    asset_id VARCHAR(10),
    machine_name VARCHAR(50),
    sensor_type VARCHAR(20),
    value FLOAT,
    unit VARCHAR(10),
    [datetime] DATETIME2
);

BULK INSERT industrial_sensor_data
FROM 'D:\Projets_GitHub\industrial-sensor-data-pipeline\data\industrial_sensor_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

SELECT * FROM industrial_sensor_data
