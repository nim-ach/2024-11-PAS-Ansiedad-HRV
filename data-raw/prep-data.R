
# Prepare workspace -------------------------------------------------------

## Load libraries
library(data.table)

## Load data
pas_data <- fread(file = "data-raw/raw_data.csv")

## Assign variables code names
names(pas_data) <- readLines("data-raw/labels.txt")

## Select variables
pas_data <- pas_data[, .SD, .SDcols = readLines("data-raw/select_vars.txt")]

## Change character to numeric variables where is a number
ind_to_number <- pas_data[, lapply(.SD, \(x) any(grepl(x, pattern = "[1-9]")))] |>
  as.logical()

## Except in known nominal values
ind_to_number[1:7] <- FALSE
var_to_num <- names(pas_data)[ind_to_number]

## Convert to double precision number
pas_data[, (var_to_num) := lapply(.SD, \(x) {
  gsub(pattern = "\\s+", replacement = "", x) |>
    as.double() |>
    suppressWarnings()
}), .SDcols = var_to_num][]


# Explore visually the data -----------------------------------------------

n_breaks <- 30 ## For better resolution

pas_data[, hist(age, breaks = n_breaks)]
pas_data[, hist(hsps_score, breaks = n_breaks)]
pas_data[, hist(bai_score, breaks = n_breaks)] # Asymmetric
pas_data[, hist(sft_t2m, breaks = n_breaks)]
pas_data[, hist(mean_rr_pre, breaks = n_breaks)] # Extreme value?

## Fixed wrong RR interval using mean HR
pas_data[which.min(mean_rr_pre), mean_rr_pre := round(60000/mean_hr_pre)]
pas_data[, hist(mean_rr_pre, breaks = n_breaks)] # Looks good

pas_data[, hist(mean_hr_pre, breaks = n_breaks)]
pas_data[, hist(rmssd_pre, breaks = n_breaks)] ## Kinda asymmetric
pas_data[, hist(sdnn_pre, breaks = n_breaks)]
pas_data[, hist(hf_pre, breaks = n_breaks)] ## Asymmetric
pas_data[, hist(log(hf_pre, base = 10), breaks = n_breaks)] ## Log
pas_data[, hist(lf_pre, breaks = n_breaks)] ## Asymmetric
pas_data[, hist(log(lf_pre, base = 10), breaks = n_breaks)] ## Log
pas_data[, hist(vlf_pre, breaks = n_breaks)] ## Asymmetric
pas_data[, hist(log(vlf_pre, base = 10), breaks = n_breaks)] ## Log
pas_data[, hist(sns_ndex_pre, breaks = n_breaks)] ## Kinda asymmetric
pas_data[, hist(pns_ndex_pre, breaks = n_breaks)]
pas_data[, hist(stress_ndex_pre, breaks = n_breaks)]


# Creamos un identificador único para cada persona ------------------------

## Examinamos pares de rut, nombre y apellido en busca de datos mal tabulados
# pas_data[, list(id = rleid(tolower(rut)), rut, trimws(first_name), trimws(last_name))] |> View()

## Corregimos los errores y volvemos a revisar
pas_data[rut == "4033576-5", rut := "4003576-5"]
pas_data[rut == "7184434-6", rut := "7184324-6"]
pas_data[last_name == "Nancuante", rut := "6600417-1"]
pas_data[rut == "6895698-5", rut := "6985698-5"]
pas_data[rut == "5555183-9", rut := "5555183-4"]

## Creamos identificador
pas_data[, id := rleid(tolower(rut))][]
pas_data[, id := factor(id)][]

pas_data[id == 60, sex := "Masculino"][]
pas_data[id == 23, age := c(69, 70)][]

## Eliminamos datos personales inecesarios
pas_data[, `:=`(record_id = NULL, first_name = NULL,
                last_name = NULL, rut = NULL)]

## Character variables to factor
pas_data[, .SD, .SDcols = is.character]
pas_data[, `:=`(
  trial_phase = factor(trial_phase, levels = c("Fase 3", "Fase 4"), labels = c("t-1", "t-2")),
  sex = factor(sex, levels = c("Masculino", "Femenino"), labels = c("Male", "Female")),
  spaq_seasonal_pattern = factor(
    x = spaq_seasonal_pattern,
    levels = c("Patrón Verano", "Patrón invierno", "Ambos", "Ausencia"),
    labels = c("Summer", "Winter", "Both", "None")),
  spaq_ssi = factor(
    x = spaq_ssi,
    levels = c("Puntaje promedio", "Winter blues", "SAD"),
    labels = c("Average", "Winter Blues", "SAD"),
    ordered = TRUE),
  spaq_severity = factor(
    x = spaq_severity,
    levels = c("No es problema", "Leve", "Moderado", "Importante", "Grave", "Severo"),
    labels = c("Not a problem", "Mild", "Moderate", "Important", "Serious", "Severe"),
    ordered = TRUE),
  bai_cat = factor(
    x = bai_cat,
    levels = c("Muy baja", "Moderada", "Alta"),
    labels = c("Low", "Moderate", "High"),
    ordered = TRUE),
  sft_t2m_cat = factor(
    x = sft_t2m_cat,
    levels = c("BAJO RANGO", "NORMAL", "ALTO RANGO"),
    labels = c("Low", "Moderate", "High"),
    ordered = TRUE)
)]

# Save the data -----------------------------------------------------------

save(pas_data, file = "data/pas_data.RData")
