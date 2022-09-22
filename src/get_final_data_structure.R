library(tidyverse)

path_cameras <- "data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv"
path_coordinates <- "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv"
path_trapping <- "data/raw/robinson_coati_detection_camera_traps/trapping.csv"
path_sighting <- "data/raw/robinson_coati_detection_camera_traps/observations.csv"
path_hunting <- "data/raw/robinson_coati_detection_camera_traps/hunting.csv"
output_path <- "/workdir/data"
path_list <- list("hunting" = path_hunting, "trapping" = path_trapping, "sighting" = path_sighting)
path_config <- list("field" = path_list, "cameras" = path_cameras, "coordinates" = path_coordinates, "output_path" = output_path)

robinson::get_multisession_structures_by_method(path_config)
