# ==================================================== 
# 📊 Yahoo Finance Analysis 2018-2023
# Autor: Jesús Fontalvo
# Descripción: Limpieza, exploración y análisis visual
# ====================================================

# 1. Librerias --------------------------------------------------------------
required_pkgs <- c("readxl", "dplyr", "janitor", "skimr", "corrplot", "ggplot2", "here", "lubridate")
missing_pkgs <- required_pkgs[!required_pkgs %in% installed.packages()[, "Package"]]
if(length(missing_pkgs)) install.packages(missing_pkgs, repos = "https://cloud.r-project.org")
invisible(lapply(required_pkgs, library, character.only = TRUE))

# 2. Paths y comprobaciones -------------------------------------------------
data_path <- here::here("data", "yahoo_data.xlsx")
outputs_dir <- here::here("outputs")
if(!dir.exists(outputs_dir)) dir.create(outputs_dir, recursive = TRUE)
if(!file.exists(data_path)) stop(sprintf("El archivo de datos no existe: %s", data_path))

# 3. Cargar dataset ---------------------------------------------------------
df <- readxl::read_excel(data_path)
df <- janitor::clean_names(df)

# Ver columnas esperadas: date y adj_close (u otras variantes)
possible_date_cols <- c("date", "fecha")
possible_adj_cols <- c("adj_close", "adj_close_price", "adjusted", "adjclose", "abj_closes")
date_col <- intersect(names(df), possible_date_cols)
adj_col <- intersect(names(df), possible_adj_cols)
if(length(date_col) == 0) stop("No se encontró una columna de fecha (buscando: date, fecha)")
if(length(adj_col) == 0) stop(paste0("No se encontró columna de precio ajustado. Columnas disponibles: ", paste(names(df), collapse=", ")))


# Normalizar nombres usados internamente (rename seguro)
if(length(date_col) >= 1) names(df)[names(df) == date_col[1]] <- "date"
if(length(adj_col) >= 1) names(df)[names(df) == adj_col[1]] <- "adj_close"

# Convertir fecha a Date si necesario (intentar varios formatos)
if(!inherits(df$date, "Date")) {
  # Primero intentar as.Date directo
  parsed <- tryCatch(as.Date(df$date), error = function(e) NA)
  if(all(is.na(parsed))) {
    # Intentar con lubridate con órdenes comunes
    parsed2 <- lubridate::parse_date_time(df$date, orders = c("Ymd", "ymd", "dmy", "mdy", "Y-m-d", "d-m-Y", "m/d/Y", "d/m/Y"))
    parsed <- as.Date(parsed2)
  }
  df$date <- parsed
}

# 4. Inspección rápida ------------------------------------------------------
cat(sprintf("Filas: %d, Columnas: %d\n", nrow(df), ncol(df)))
print(skimr::skim(df))

# 5. Correlaciones y guardado -----------------------------------------------
num_var <- df %>% dplyr::select_if(is.numeric)
if(ncol(num_var) < 2) {
  warning("No hay suficientes variables numéricas para calcular correlaciones")
} else {
  cor_mat <- cor(num_var, use = "pairwise.complete.obs")
  # Guardar matriz de correlación
  write.csv(cor_mat, file = file.path(outputs_dir, "correlation_matrix.csv"), row.names = TRUE)
  # Mostrar plot de corr
  png(filename = file.path(outputs_dir, "correlation_matrix.png"), width = 800, height = 600)
  corrplot::corrplot(cor_mat, method = "color", type = "upper", tl.col = "black")
  dev.off()
}

# 6. Gráfico de precio ajustado en el tiempo --------------------------------
plt <- ggplot2::ggplot(df, aes(x = date, y = adj_close)) +
  ggplot2::geom_line(color = "#2c3e50") +
  ggplot2::labs(title = "Precio ajustado a lo largo del tiempo", x = "Fecha", y = "Precio ajustado") +
  ggplot2::theme_minimal()
# Guardar gráfico
ggplot2::ggsave(filename = file.path(outputs_dir, "adj_close_timeseries.png"), plot = plt, width = 10, height = 5)

cat("Análisis completado. Archivos generados en: ", outputs_dir, "\n")

