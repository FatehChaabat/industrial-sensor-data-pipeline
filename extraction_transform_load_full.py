from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime
import time

start = time.time()

#~ Chargement a partir de SQL
engine = create_engine(
    "mssql+pyodbc://localhost/INDUSTRIAL_DATA"
    "?driver=ODBC+Driver+18+for+SQL+Server"
    "&trusted_connection=yes"
    "&Encrypt=no"
)

#~ option 1: récuperer industrial_sensor_data à partir de sql (si les données sont dispo dans la base de données sql)
# df = pd.read_sql("SELECT * FROM industrial_sensor_data", engine)

#~ option 2: Chargement de fichier .csv directement 
df_raw = pd.read_csv("data/industrial_sensor_data.csv")

#~ OPTIONNEL : sauvegarde RAW
df_raw.to_sql("industrial_sensor_data", engine, if_exists="replace", index=False)

#* Garde les données brutes df_raw intactes
df = df_raw.copy()

#* Compare entrée/sortie
input_count = df.shape[0]
print(f"Lignes en entrée : {input_count}")

#~ Transformation : stats et anomalies (possible de le faire sur sql ou DAX directement pour activer les filtres)
stats = df.groupby(["machine_name", "sensor_type"]).agg(
    avg_value=("value", "mean"),
    max_value=("value", "max"),
    min_value=("value", "min")
).round(3).reset_index()
df = df.merge(stats, on=["machine_name", "sensor_type"])

df["z_score"] = df.groupby(["machine_name", "sensor_type"])["value"].transform(
    lambda x: (x - x.mean()) / x.std() if x.std() != 0 else 0)
df["anomaly"] = df["z_score"].abs() > 3

#* Juste pour vérification dans Power BI
df["run_timestamp"] = datetime.now()


#~ Envoi vers SQL pour exploit en POWER BI
df.to_sql(
    "industrial_sensor_bi_full",
    engine,
    if_exists="replace",
    index=False,
    chunksize=1000
)

#* vérification des données de sortie
output_count = pd.read_sql("SELECT COUNT(*) as cnt FROM industrial_sensor_bi_full", engine)
print(f"Lignes en sortie : {output_count['cnt'][0]}")

#* Creer un fichier log.txt qui trace les excutions !
with open("pipeline.log", "a") as f:
    f.write(
        f"Run OK - {datetime.now()} | "
        f"input_rows={input_count} | "
        f"output_rows={output_count['cnt'][0]} | "
        f"anomalies_count={df['anomaly'].sum()}\n"
    )

print("Pipeline terminé")

end = time.time()
print(f"Temps d'exécution : {end - start:.2f} secondes")