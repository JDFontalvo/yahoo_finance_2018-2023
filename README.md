# 📈 Yahoo Finance Analysis 2018-2023

## 📝 Descripción del Proyecto

Este proyecto contiene un conjunto de scripts en **R** diseñados para realizar la **limpieza**, **exploración** y **visualización** de datos históricos de precios de acciones (series temporales) obtenidos de Yahoo Finance. El objetivo es generar métricas clave y gráficos que muestren las tendencias y relaciones de los precios ajustados a lo largo del periodo **2018-2023**.

<br>

## 📁 Origen del Dataset

Los datos utilizados para este análisis son precios históricos de acciones obtenidos de **Yahoo Finance**.

El archivo de entrada esperado en la carpeta `data/` (`stocks_data.xlsx`) contiene series de tiempo para múltiples activos en el periodo 2018-2023.

  * **Fuente Principal:** [Yahoo Finance](https://finance.yahoo.com/)
  * **Referencia de Dataset Similar :
      * [Yahoo Finance Dataset (2018-2023) en Kaggle](https://www.kaggle.com/datasets/suruchiarora/yahoo-finance-dataset-2018-2023)

<br>

## 📂 Estructura del Proyecto

La estructura de directorios organiza el código, los datos y los resultados generados:

```
yahoo-finance-analysis/
├── .github/
│   └── workflows/
│       └── r-ci.yml        # Workflow de GitHub Actions para CI/CD (Test y generación de artefactos)
├── data/
│   └── stocks_data.xlsx    # Archivo de entrada (requerido) con datos de Yahoo Finance.
├── outputs/
│   └── (archivos de salida generados)
├── scripts/
│   └── analysis.R          # Script principal para limpieza, análisis y generación de salidas.
├── .gitignore
└── README.md
```

-----

## ⚙️ Requisitos

Para ejecutar el script localmente, necesitas tener instalado **R** (versión **\>= 4.0**) y los siguientes paquetes:

  * `readxl`
  * `dplyr`
  * `janitor`
  * `skimr`
  * `corrplot`
  * `ggplot2`
  * `here`
  * `lubridate`

-----

## 🚀 Uso

Asegúrate de colocar tu archivo de datos de precios en la carpeta `data/` con el nombre `stocks_data.xlsx`.

Desde la raíz del proyecto, ejecuta el script de análisis usando la terminal:

```powershell
Rscript scripts/analysis.R
```

<br>

### ⚠️ Notas Importantes

El script **intenta detectar automáticamente** las columnas de fecha y precio ajustado. Si tus columnas tienen nombres distintos, renómbralas a `date` y `adj_close` en el archivo de entrada, o ajusta el vector `possible_adj_cols` dentro de `scripts/analysis.R`.

-----

## 📊 Salida (Outputs)

Los archivos generados por el script se guardan automáticamente en la carpeta `outputs/`:

| Archivo | Tipo | Descripción |
| :--- | :--- | :--- |
| `correlation_matrix.csv` | CSV | Matriz de correlación de los precios ajustados. |
| `correlation_matrix.png` | PNG | Visualización gráfica de la matriz de correlación. |
| `adj_close_timeseries.png` | PNG | Gráfico de serie temporal del precio ajustado a lo largo del periodo 2018-2023. |

-----

## 🌐 Configuración y Subida a GitHub

### Verificación Local

Antes de subir, puedes verificar que el script se ejecuta correctamente:

```powershell
Rscript scripts/analysis.R
```

### Pasos de Subida (Terminal / PowerShell)

Sigue estos comandos desde la raíz de tu proyecto para inicializar Git y publicar tu código en un nuevo repositorio de GitHub.

1.  **Inicializar Git y primer commit:**

    ```powershell
    git init
    git add .
    git commit -m "Initial commit: proyecto Yahoo Finance analysis"
    ```

2.  **Crear el repositorio remoto y subir (Usando GitHub CLI - `gh`):**

    Si tienes `gh` instalado, esta es la forma más rápida (reemplaza `<usuario>` y `<repo-name>`):

    ```powershell
    gh repo create <usuario>/<repo-name> --public --source=. --remote=origin --push
    ```

3.  **Añadir remote y subir manualmente (Si no usas `gh`):**

    Crea el repositorio vacío en GitHub.com primero, luego ejecuta (reemplaza la URL):

    ```powershell
    git remote add origin https://github.com/<usuario>/<repo>.git
    git branch -M main
    git push -u origin main
    ```

### Integración Continua (CI)

El archivo `.github/workflows/r-ci.yml` está configurado para ejecutarse en cada *push*. Este workflow:

  * Verifica la sintaxis del código.
  * Ejecuta el script `analysis.R` en el servidor de GitHub.
  * Los archivos generados (`.csv` y `.png`) se guardan como **artefactos** del *job*.

Puedes ver los archivos de salida generados por el CI en la pestaña **Actions** $\rightarrow$ selecciona el *job* $\rightarrow$ **Artifacts**.
