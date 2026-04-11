# Pipeline de Données Capteurs Industriels & Détection d'Anomalies

> Pipeline complet de traitement de données industrielles, de l'ingestion CSV jusqu'au dashboard Power BI, assurant la qualité et la cohérence des données, avec détection d'anomalies par Z-Score.

![Python](https://img.shields.io/badge/Python-3.10-blue)
![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-Developer-red?logo=microsoft-sql-server)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🚀 Vue d'ensemble
Ce projet simule un système industriel de supervision de capteurs permettant :

- ingestion de données brutes
- stockage en base SQL Server
- traitement, détection d’anomalies et enrichissement via Python
- visualisation dans Power BI


```mermaid
flowchart LR

A[<b>📄 CSV</b>] --> B[<b>🗄️ SQL Server : raw</b>]
B --> C[<b>🐍 Python : clean + compute</b>]
C --> D[<b>🗄️ SQL Server : enriched</b>]
D --> E[<b>📊 Power BI : dataset + reports + dashboards</b>]

%% Styles
classDef sql fill:#e3f2fd,stroke:#1e88e5,stroke-width:2px,color:#000;
classDef python fill:#e8f5e9,stroke:#43a047,stroke-width:2px,color:#000;
classDef power_bi fill:#fce4ec,stroke:#d81b60,stroke-width:2px,color:#000;

%% Affectation
class A,B,D sql;
class C python;
class E power_bi;
```

| Métrique | Valeur |
|---|---|
| Observations | 2 000 |
| Équipements surveillés | 4 (échangeur, compresseur, turbine, pompe) |
| Types de capteurs | 3 (température, débit, pression) |
| Seuil d'anomalie | \|Z\| > 3 |

---

## 🎯 Objectifs et valeur métier 

- **Maintenance préventive** : détection des dérives et anomalies avant défaillance équipement 
- **Supervision continue** : monitoring régulier et automatisé multi-machines via dashboard interactif
- **Analyse comparative** : benchmark de performance entre machines et capteurs
- **Automatisation bout en bout** : exécution planifiée sans intervention manuelle via Windows Task Scheduler

---

## ⚙️ Stack technique

| Composant | Rôle | Technologies |
|---|---|---|
| Ingestion | Chargement des données CSV en base | `sqlalchemy`, `pyodbc` |
| Traitement | Nettoyage + calculs | `pandas`, `scipy` |
| Stockage | Données brutes + enrichies | SQL Server Developer |
| Visualisation | Dashboard interactif avec filtres | Power BI Desktop |
| Automatisation | Exécution planifiée du pipeline | Windows Task Scheduler |

---

## 🔬 Méthode de détection

Les anomalies sont détectées par **Z-Score** : chaque mesure est standardisée par capteur et par équipement. Un point est marqué comme anomalie si `|Z| > 3`, soit 3 écarts-types au-delà de la moyenne, correspondant statistiquement à moins de 0,3 % des observations sous distribution normale.

```python
df['z_score'] = df.groupby(['machine', 'capteur'])['valeur'] \
    .transform(lambda x: (x - x.mean()) / x.std())
df['anomalie'] = df['z_score'].abs() > 3
```

---

## 📈 Résultats
 
<!-- Ajouter une capture du dashboard Power BI ici -->
<!-- ![Dashboard](docs/dashboard_preview.png) -->
 
| Métrique | Valeur |
|---|---|
| Anomalies détectées | 2 |
| Taux d'anomalie global | 0,1 % |
| Temps d'exécution pipeline | < ~0.5 – 3s |

---

## ⚠️ Limites actuelles
- **Traitement batch** : pas d'ingestion en streaming temps réel (Kafka)
- **Pas d'orchestration** : aucune gestion native des erreurs et dépendances entre étapes (Airflow)
- **Déploiement local** : Power BI Desktop uniquement, pas de partage en ligne sans licence Power BI Pro
- **Données simulées** : les performances de détection restent à valider sur des données industrielles réelles

---

## 🔮 Améliorations futures
 
- **Pipeline incrémental** — traitement uniquement des nouvelles données à chaque exécution, sans recharger l'historique complet
- **Orchestration** — gestion des dépendances et des erreurs entre étapes via Airflow ou Prefect
- **Monitoring + alerting** — notification automatique (email, Slack) lors de la détection d'une anomalie critique
- **Power BI Service** — publication en ligne et actualisation automatique des données sans intervention manuelle
- **Temps réel** — remplacement du batch par un pipeline streaming via Kafka ou Spark Streaming

---
 
## 📁 Structure du projet
 
```
industrial-sensor-pipeline/
├── data/
│   └── sensors_raw.csv                    # données simulées
├── sql/
│   ├── create_tables.sql                   # schéma DB
│   └── queries.sql                         # requêtes analytiques
├── extraction_transform_load_full.py       # pipeline complet ETL
├── dashboard.pbix                          # Power BI dashboard
└── requirements.txt
```

---

## 🛠️ Installation & exécution

### Prérequis

- Python 3.10+
- SQL Server Developer Edition
- Power BI Desktop
- ODBC Driver 18

### Comment exécuter

```bash
# Cloner le dépôt
git clone https://github.com/fatehchaabat/industrial-sensor-data-pipeline.git
cd industrial-sensor-data-pipeline

# Installer les dépendances
pip install -r requirements.txt

# Lancer le pipeline complet (extraction → transformation → chargement)
python extraction_transform_load_full.py

```
### Configuration SQL Server
La connexion SQL Server utilise **Windows Authentication** (Trusted Connection), aucune configuration supplémentaire n'est requise si SQL Server tourne en local :
 
```python
engine = create_engine(
    "mssql+pyodbc://<SERVEUR>/<NOM_BASE>"
    "?driver=ODBC+Driver+18+for+SQL+Server"
    "&trusted_connection=yes"
    "&Encrypt=no"
)
```
 
### Connexion Power BI
 
Ouvrir `dashboard.pbix` → Transformer les données → Mettre à jour la chaîne de connexion SQL Server.



---

## 📄 Licence

MIT · [Fateh Chaabat](https://fatehchaabat.github.io)





