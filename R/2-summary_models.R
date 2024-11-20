
# Prepare workspace -------------------------------------------------------

## Load libraries
library(data.table)
library(brms)

## Source functions
source("R/_functions.R")

## Load data
data("pas_data")

## Load mdoels
m_1 <- readRDS(file = "models/m_1_fit.RDS")
m_2 <- readRDS(file = "models/m_2_fit.RDS")
m_3 <- readRDS(file = "models/m_3_fit.RDS")
m_4 <- readRDS(file = "models/m_4_fit.RDS")

# Summary models ----------------------------------------------------------

summary_1 <- summary_model(m_1, regex = "^b_") |> as.data.table()
summary_2 <- summary_model(m_2, regex = "^b_") |> as.data.table()
summary_3 <- summary_model(m_3, regex = "^b_") |> as.data.table()
summary_4 <- summary_model(m_4, regex = "^b_") |> as.data.table()

summary_1[, `:=`(BF = exp(log_BF), CI = NULL, ROPE_CI = NULL, ROPE_low = NULL, ROPE_high = NULL, log_BF = NULL)]
summary_2[, `:=`(BF = exp(log_BF), CI = NULL, ROPE_CI = NULL, ROPE_low = NULL, ROPE_high = NULL, log_BF = NULL)]
summary_3[, `:=`(BF = exp(log_BF), CI = NULL, ROPE_CI = NULL, ROPE_low = NULL, ROPE_high = NULL, log_BF = NULL)]
summary_4[, `:=`(BF = exp(log_BF), CI = NULL, ROPE_CI = NULL, ROPE_low = NULL, ROPE_high = NULL, log_BF = NULL)]

names(summary_1) <- names(summary_2) <- names(summary_3) <- names(summary_4) <-
  c("Parameter", "Median", "Low", "High", "pd", "ps", "ROPE", "BF")

summary_1[, (2:8) := lapply(.SD, round, digits = 3), .SDcols = 2:8]
summary_2[, (2:8) := lapply(.SD, round, digits = 3), .SDcols = 2:8]
summary_3[, (2:8) := lapply(.SD, round, digits = 3), .SDcols = 2:8]
summary_4[, (2:8) := lapply(.SD, round, digits = 3), .SDcols = 2:8]

saveRDS(object = summary_1, file = "models/m_1_results.RDS")
saveRDS(object = summary_2, file = "models/m_2_results.RDS")
saveRDS(object = summary_3, file = "models/m_3_results.RDS")
saveRDS(object = summary_4, file = "models/m_4_results.RDS")
