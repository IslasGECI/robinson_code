library(robinson)
library(tidyverse)

predictions_df <- read_csv("prediction_with_count_cells_coatis.csv")
ignore_month <- NULL
write_summary_for_coati_report(predictions_df, ignore_month)
