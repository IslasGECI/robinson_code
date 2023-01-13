library(robinson)
library(tidyverse)

predictions_df <- read_csv("prediction_with_count_cells.csv")
ignore_month <- "August 2022"
write_summary_for_cat_report(predictions_df, ignore_month)
