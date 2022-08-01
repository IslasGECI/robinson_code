library(tidyverse)
library(robinson)

path_cameras <- "data/raw/robinson_coati_detection_camera_traps/APRIL2022COATI.csv"
path_field <- "data/raw/robinson_coati_detection_camera_traps/trapping_hunting.csv"
path_coordinates <- "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv"

paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates) 
tidy_table <- get_tidy_from_field_and_cameras(paths)
final <- tidy_2_final(tidy_table)
write_csv(final, file = "data/april_camera_traps.csv", na = "0")
