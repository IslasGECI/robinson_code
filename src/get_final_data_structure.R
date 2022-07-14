library(tidyverse)
library(robinson)

path <- "data/raw/robinson_coati_detection_camera_traps/APRIL2022COATI.csv"
tidy_table <- tidy_from_path(path)
final <- tidy_2_final(tidy_table)
write_csv(final, file = "data/april_camera_traps.csv")
