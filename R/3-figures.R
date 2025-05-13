# Prepare workspace -------------------------------------------------------

## Load libraries
library(data.table)
library(ggplot2)
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

# BAI vs HSPS plot --------------------------------------------------------

plot_data <- m_1 |>
  tidybayes::add_epred_draws(
    newdata = expand.grid(
      trial_phase = NA,
      id = NA,
      hsps_score = seq(-2.5, 2.5, 0.25)
    ),
    allow_new_levels = TRUE,
    re_formula = NA,
    ndraws = 500
  ) |>
  subset(select = c("hsps_score", ".epred", ".draw"))

fig1 <- ggplot(plot_data, aes(hsps_score, .epred, group = .draw)) +
  geom_line(alpha = 1/10, col = "#08519C") +
  geom_smooth(col = "white", aes(group = 1), linewidth = 1.5, method = "lm") +
  theme_classic() +
  labs(y = "BAI (z-score)", x = "HSPS (z-score)") +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0))

ggsave(filename = "figures/fig1.pdf", fig1, width = 7, height = 5)
ggsave(filename = "figures/fig1.png", fig1, width = 7, height = 5, dpi = 400)


# HRV vs Ansiedad ----------------------------------------------------------

plot_data <- m_3 |>
  tidybayes::add_epred_draws(
    newdata = expand.grid(
      trial_phase = NA,
      id = NA,
      hsps_score = 0,
      bai_score = seq(-2.5, 2.5, 0.25)
    ),
    allow_new_levels = TRUE,
    re_formula = NA,
    ndraws = 500
  ) |>
  subset(select = c("bai_score", ".epred", ".category", ".draw"))

plot_data <- within(plot_data, {
  .category <- gsub("pre$", "", .category) |>
    factor(levels = c("pnsndex", "snsndex", "stressndex", "hf", "lf", "vlf", "rmssd", "sdnn"),
           labels = c("PNS Index", "SNS Index", "Stress Index", "HF", "LF", "VLF", "RMSSD", "SDNN"))
})

fig2 <- ggplot(plot_data, aes(bai_score, .epred, group = .draw)) +
  facet_wrap(~ .category) +
  geom_line(alpha = 1/10, col = "#08519C") +
  geom_smooth(col = "white", aes(group = 1), linewidth = 1.5, method = "lm") +
  theme_classic() +
  labs(y = "HRV value (z-score)", x = "BAI (z-score)") +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0))

ggsave(filename = "figures/fig2.pdf", fig2, width = 7, height = 7)
ggsave(filename = "figures/fig2.png", fig2, width = 7, height = 7, dpi = 400)


