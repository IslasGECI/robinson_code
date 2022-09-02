library(tidyverse)
library(robinson)

path_cameras <- "data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv"
path_field <- "data/raw/robinson_coati_detection_camera_traps/trapping_hunting.csv"
path_coordinates <- "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv"

paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates) 
tidy_table <- get_tidy_from_field_and_cameras(paths)

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(4)
filter_tidy$select_method("Hunting")
hunting_structure <- filter_tidy$spatial()
write_csv(hunting_structure, file = "data/april_hunting.csv", na = "0")

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(4)
filter_tidy$select_method("Trapping")
trapping_structure <- filter_tidy$spatial()
write_csv(trapping_structure, file = "data/april_trapping.csv", na = "0")

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(4)
filter_tidy$select_method("Observation")
observations_structure <- filter_tidy$spatial()

write_csv(observations_structure, file = "data/april_observations.csv", na = "0")
number_month <- 7
filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(number_month)
filter_tidy$select_method("Camera-Traps")
camera_traps_structure <- filter_tidy$spatial()
write_csv(camera_traps_structure, file = path_for_cameras(number_month), na = "0")
