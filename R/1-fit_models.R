
# Prepare workspace -------------------------------------------------------

## Load Libraries
library(data.table)
library(datawizard)
library(brms)

## Load data
data("pas_data")

## Standardize data
m_data <- standardize(pas_data)

# Fit models --------------------------------------------------------------

## Model 1: BAI ~ N(PAS + Covariables) ----

### Prepare model
m_1_formula <- bf(
  bai_score ~ hsps_score + trial_phase + (1|id)
)

### Prepare priors
get_prior(m_1_formula, m_data)
m_1_prior <-
  prior(normal(0,3), class = b) +
  prior(normal(0,3), class = sd)

### Fit model
m_1_fit <- brm(
  formula = m_1_formula,
  data = m_data,
  family = gaussian(),
  prior = m_1_prior,
  seed = 1234,
  chains = 4, cores = 4,
  iter = 5000, warmup = 2500,
  control = list(adapt_delta = .99,
                 max_treedepth = 50),
  file = "models/m_1_fit.RDS"
)

## Model 2: HRV ~ N(BAI) ----

### Prepare model
m_2_formula <- bf(
  mvbind(rmssd_pre, sdnn_pre, hf_pre, lf_pre, vlf_pre,
         pns_ndex_pre, sns_ndex_pre, stress_ndex_pre) ~ 1 +
    bai_score + trial_phase + (1|id)
) + set_rescor(TRUE)

### Prepare priors
get_prior(m_2_formula, m_data)
m_2_prior <-
  set_prior("normal(0,3)", class = "b", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre")) +
  set_prior("normal(0,3)", class = "sd", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre"), lb = 0) +
  set_prior("normal(0,3)", class = "sigma", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre"), lb = 0)

### Fit model
m_2_fit <- brm(
  formula = m_2_formula,
  data = m_data,
  family = gaussian(),
  prior = m_2_prior,
  seed = 1234,
  chains = 4, cores = 4,
  iter = 5000, warmup = 2500,
  control = list(adapt_delta = .99,
                 max_treedepth = 50),
  file = "models/m_2_fit.RDS"
)

## Model 3: HRV ~ N(BAI + PAS + Covariables) ----

### Prepare model
m_3_formula <- bf(
  mvbind(rmssd_pre, sdnn_pre, hf_pre, lf_pre, vlf_pre,
         pns_ndex_pre, sns_ndex_pre, stress_ndex_pre) ~ 1 +
    bai_score + hsps_score + trial_phase +
    (1|id)
) + set_rescor(TRUE)

### Prepare priors
get_prior(m_3_formula, m_data)
m_3_prior <-
  set_prior("normal(0,3)", class = "b", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre")) +
  set_prior("normal(0,3)", class = "sd", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre"), lb = 0) +
  set_prior("normal(0,3)", class = "sigma", resp = c("rmssdpre", "sdnnpre", "hfpre", "lfpre", "vlfpre", "pnsndexpre", "snsndexpre", "stressndexpre"), lb = 0)

### Fit model
m_3_fit <- brm(
  formula = m_3_formula,
  data = m_data,
  family = gaussian(),
  prior = m_3_prior,
  seed = 1234,
  chains = 4, cores = 4,
  iter = 5000, warmup = 2500,
  control = list(adapt_delta = .99,
                 max_treedepth = 50),
  file = "models/m_3_fit.RDS"
)



