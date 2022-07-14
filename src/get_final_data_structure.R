library(tidyverse)
library(robinson)

path <- "data/raw/robinson_coati_detection_camera_traps/APRIL2022COATI.csv"
tidy_table <- tidy_from_path(path)
print(tidy_table)
