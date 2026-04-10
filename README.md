# Pipeline de Données Capteurs Industriels & Détection d'Anomalies

> Pipeline complet de traitement de données industrielles de l'ingestion CSV jusqu'au dashboard Power BI, avec détection d'anomalies par Z-Score.

![Python](https://img.shields.io/badge/Python-3.10-blue)
![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-Developer-red?logo=microsoft-sql-server)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🚀 Vue d'ensemble
Ce projet simule un système industriel réel de supervision et de maintenance prédictive basé sur des données capteurs.



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

## 🎯 Valeur métier

- **Maintenance préventive** — détection des dérives avant défaillance équipement
- **Supervision continue** — monitoring multi-machines en temps quasi-réel
- **Aide à la décision** — identification rapide des anomalies critiques via dashboard interactif
- **Analyse comparative** — benchmark de performance entre machines et capteurs

---

## ⚙️ Stack technique

| Composant | Rôle | Technologies |
|---|---|---|
| Ingestion | Chargement des données CSV en base | `pyodbc`, SQL Server |
| Traitement | Nettoyage, Z-Score, enrichissement | `pandas`, `scipy` |
| Stockage | Données brutes + enrichies, requêtes analytiques | SQL Server Developer |
| Visualisation | Dashboard interactif avec filtres | Power BI Desktop |
| Automatisation | Exécution planifiée du pipeline | Windows Task Scheduler |

---

## 🔬 Méthode de détection

Les anomalies sont détectées par **Z-Score** : chaque mesure est standardisée par capteur et par équipement. Un point est marqué comme anomalie si `|Z| > 3`, soit 3 écarts-types au-delà de la moyenne — correspondant statistiquement à moins de 0,3 % des observations sous distribution normale.

```python
df['z_score'] = df.groupby(['machine', 'capteur'])['valeur'] \
    .transform(lambda x: (x - x.mean()) / x.std())
df['anomalie'] = df['z_score'].abs() > 3
```

> 💡 Le seuil `|Z| > 3` est configurable dans `config.py`. Un seuil à 2,5 augmente la sensibilité au détriment du taux de faux positifs.

---

## 🛠️ Installation & lancement

### Prérequis

- Python 3.10+
- SQL Server Developer Edition
- Power BI Desktop
- ODBC Driver 17+

### Setup

```bash
# 1. Cloner le repo
git clone https://github.com/fatehchaabat/industrial-sensor-pipeline.git
cd industrial-sensor-pipeline

# 2. Installer les dépendances
pip install -r requirements.txt

# 3. Configurer la connexion SQL Server
cp config.example.py config.py
# → éditer SERVER, DATABASE, USERNAME, PASSWORD

# 4. Initialiser la base de données
python setup_db.py

# 5. Lancer le pipeline
python pipeline.py
```

### Connexion Power BI

Ouvrir `dashboard.pbix` → Transformer les données → Mettre à jour la chaîne de connexion SQL Server.

---

## 📈 Résultats

<!-- Ajouter une capture du dashboard Power BI ici -->
<!-- ![Dashboard](docs/dashboard_preview.png) -->

| Métrique | Valeur |
|---|---|
| Anomalies détectées | ~XX |
| Taux d'anomalie global | X,X % |
| Temps d'exécution pipeline | < Xs |

---

## 📁 Structure du projet

```
industrial-sensor-pipeline/
├── data/
│   └── sensors_raw.csv          # données simulées
├── sql/
│   ├── create_tables.sql         # schéma DB
│   └── queries.sql               # requêtes analytiques
├── pipeline.py                   # script principal
├── config.example.py             # template de configuration
├── setup_db.py                   # init base de données
├── dashboard.pbix                # Power BI dashboard
└── requirements.txt
```

---

## 📄 Licence

MIT · [Fateh Chaabat](https://fatehchaabat.github.io)





