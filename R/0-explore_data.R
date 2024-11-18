
# Prepare workspace -------------------------------------------------------

## Load libraries
library(data.table)
library(skimr)

## Load dataset
data("pas_data")

# Visualize data ----------------------------------------------------------

skimr::skim(pas_data)
#> ── Data Summary ────────────────────────
#>                            Values
#> Name                       pas_data
#> Number of rows             190
#> Number of columns          25
#> Key                        NULL
#> _______________________
#> Column type frequency:
#>   character                11
#>   numeric                  14
#> ________________________
#> Group variables            None
#>
#> ── Variable type: character ─────────────────────────────────────────────────────────────────────────────────────
#>    skim_variable         n_missing complete_rate min max empty n_unique whitespace
#>  1 record_id                     0             1   1  26     0      124          0
#>  2 redcap_event_name             0             1   6   6     0        2          0
#>  3 first_name                    0             1   3  21     0      154          0
#>  4 last_name                     0             1   3  22     0      166          0
#>  5 sex                           0             1   8   9     0        2          0
#>  6 rut                           0             1   0  10     1      132          0
#>  7 spaq_seasonal_pattern         0             1   0  15     1        5          0
#>  8 spaq_ssi                      0             1   0  16     1        5          0
#>  9 spaq_severity                 0             1   0  14     4        7          0
#> 10 bai_cat                       0             1   0   8     4        4          0
#> 11 sft_t2m_cat                   0             1   0  10    11        4          0
#>
#> ── Variable type: numeric ───────────────────────────────────────────────────────────────────────────────────────
#>    skim_variable   n_missing complete_rate    mean      sd     p0    p25    p50    p75    p100 hist
#>  1 age                     0         1      71.2     6.05   57     67     70.5   75      89    ▂▇▇▃▁
#>  2 hsps_score              0         1      76.9    16.3    40     66     76     88     114    ▂▆▇▆▂
#>  3 bai_score              16         0.916   6.20    6.65    0      0.25   4      9.75   27    ▇▃▂▁▁
#>  4 sft_t2m                 9         0.953  88.8    24.2    26     74     88    105     160    ▂▅▇▃▁
#>  5 mean_rr_pre             7         0.963 866.    118.    589    786.   840    936    1212    ▂▇▆▃▁
#>  6 rmssd_pre               7         0.963  14.8     6.28    3.8   10.4   14.5   18.6    37    ▅▇▅▁▁
#>  7 pns_ndex_pre            6         0.968  -0.959   0.678  -2.63  -1.43  -1.01  -0.49    1.12 ▁▇▇▃▁
#>  8 mean_hr_pre             6         0.968  70.6     9.61   49     64     71     76.2   102    ▂▆▇▂▁
#>  9 stress_ndex_pre         6         0.968  23.4     6.97    1.6   18.7   22.2   27.1    52.1  ▁▇▇▁▁
#> 10 sns_ndex_pre            6         0.968   2.49    1.50   -0.11   1.57   2.20   3.23    9.27 ▆▇▂▁▁
#> 11 sdnn_pre                6         0.968  15.7     5.25    4.7   11.9   15.8   19.7    31.8  ▃▆▇▃▁
#> 12 vlf_pre                 6         0.968  32.6    31.7     1     12     25.5   40     249    ▇▂▁▁▁
#> 13 lf_pre                  6         0.968 134.    120.      7     57.5  100.   177     702    ▇▃▁▁▁
#> 14 hf_pre                  6         0.968  82      70.8     3     30.8   56.5  117.    317    ▇▃▂▁▁
