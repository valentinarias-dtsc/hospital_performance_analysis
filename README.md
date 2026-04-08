# Hospital Performance Analysis

## Overview

Este proyecto tiene como objetivo el análisis del desempeño hospitalario a partir de un enfoque estructurado de ingeniería y análisis de datos. Se construye un pipeline completo que abarca desde la ingesta de datos hasta la generación de métricas analíticas listas para su exploración.

El foco principal está en el diseño de un **Hospital Performance Index (HPI)**, que permite evaluar y comparar hospitales en función de calidad, eficiencia y costo.

---

## Objetivos

- Modelar un dataset de salud en un entorno relacional (**PostgreSQL**)
- Aplicar **data cleaning y feature engineering** en SQL
- Definir y calcular un índice compuesto (**HPI**)
- Construir una capa analítica reutilizable mediante **views**
- Preparar los datos para análisis exploratorio y visualización

---

## Dataset

- Nombre: `pakistan_healthcare_dataset`
- Registros: ~5500
- Variables: 36
- Unidad de análisis: hospitales

---

## Tech Stack

**Base de datos**
- PostgreSQL

**Lenguaje**
- SQL (transformaciones y modelado)
- Python (EDA – en desarrollo)

**Librerías previstas**
- pandas, numpy
- matplotlib, seaborn
- sqlalchemy, psycopg2
- python-dotenv
- (opcional) pingouin / scikit-learn

**Herramientas**
- Visual Studio Code
- SQLTools

---

## Data Pipeline

El flujo de datos sigue una arquitectura clara y reproducible:

CSV → PostgreSQL (RAW) → Data Quality → Feature Engineering → HPI → VIEW final

### Scripts SQL

- `01_schema.sql` → definición de tabla RAW  
- `02_import.sql` → carga de datos desde CSV  
- `03_data_quality.sql` → validación de calidad de datos  
- `04_feature_engineering.sql` → limpieza y generación de variables  
- `05_hpi_calculation.sql` → cálculo del índice HPI  
- `06_final_table.sql` → construcción de vista final analítica  

---

## Data Model

### Tablas

- `hospital_performance_raw` → datos originales
- `hospital_performance_clean` → datos procesados

### Views

- `hospital_performance_hpi` → métricas y componentes del índice
- `hospital_performance_final` → dataset final listo para análisis

---

## Hospital Performance Index (HPI)

El HPI es un índice compuesto diseñado para sintetizar el desempeño hospitalario en tres dimensiones:

### Fórmula general

HPI = 0.5Q + 0.3E + 0.2C

### Componentes

**Quality (Q)**  
Q = (mortality + readmission + satisfaction + infection) / 4

**Efficiency (E)**  
E = (length_stay + wait_time) / 2

**Cost (C)**  
C = avg_treatment_cost

### Metodología

- Normalización de variables  
- Inversión de métricas negativas (ej: mortalidad, tiempos, costos)  
- Agregación por dimensión  
- Ponderación final  

---

## Decisiones de Diseño

- Uso de **PostgreSQL como motor principal**
- Pipeline SQL modular y desacoplado
- Separación clara entre:
  - datos crudos
  - datos limpios
  - capa analítica
- Implementación de **views en lugar de tablas materializadas**
  - evita duplicación de datos
  - mejora trazabilidad
- Feature engineering realizado en SQL (no en Python)
- Enfoque **DB-first**, priorizando lógica en base de datos

---

## Estructura del Repositorio
```
├── data/
│   └── raw/
│       └── pakistan_healthcare.csv
├── Notebooks/
│   └── EDA.ipynb
├── SQL/
│   ├── 01_schema.sql
│   ├── 02_import.sql
│   ├── 03_data_quality.sql
│   ├── 04_feature_engineering.sql
│   ├── 05_hpi_calculation.sql
│   └── 06_final_table.sql
├── README.md
└── LICENSE
```
---

## Uso

1. Crear la base de datos en PostgreSQL  
2. Ejecutar los scripts SQL en orden (`01` → `06`)  
3. Asegurar que el dataset esté disponible en:  
   `C:/Github/hospital_performance_analysis/data/raw/pakistan_healthcare.csv`  
4. Conectarse a la base de datos desde Python para análisis  

---

## Estado del Proyecto

- Pipeline de datos: ✔ completo  
- Cálculo del HPI: ✔ implementado  
- Dataset analítico: ✔ disponible (view)  
- EDA: en desarrollo  