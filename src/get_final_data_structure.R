library(tidyverse)
library(robinson)

path_cameras <- "data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv"
path_coordinates <- "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv"
path_trapping <- "data/raw/robinson_coati_detection_camera_traps/trapping.csv"
path_sighting <- "data/raw/robinson_coati_detection_camera_traps/observations.csv"
path_hunting <- "data/raw/robinson_coati_detection_camera_traps/hunting.csv"
path_list <- list("hunting" = path_hunting, "trapping" = path_trapping, "sighting" = path_sighting)
path_config <- list("field" = path_list, "cameras" = path_cameras, "coordinates" = path_coordinates)
tidy_table <- get_tidy_from_field_and_cameras(path_config)
session <- "2022-4"
filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(session)
filter_tidy$select_method("Hunting")
hunting_structure <- filter_tidy$spatial()
write_csv(hunting_structure, file = "data/april_hunting.csv", na = "0")

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(session)
filter_tidy$select_method("Trapping")
trapping_structure <- filter_tidy$spatial()
write_csv(trapping_structure, file = "data/april_trapping.csv", na = "0")

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(session)
filter_tidy$select_method("Observation")
observations_structure <- filter_tidy$spatial()
write_csv(observations_structure, file = "data/april_observations.csv", na = "0")

filter_tidy <-Filter_tidy$new(tidy_table)
filter_tidy$select_session(session)
filter_tidy$select_method("Camera-Traps")
camera_traps_structure <- filter_tidy$spatial()
write_csv(camera_traps_structure, file = "data/april_camera_traps.csv", na = "0")
