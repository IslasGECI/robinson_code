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
year <- "2022-"
methods <- c("Hunting", "Trapping", "Observation", "Camera-Traps")
for (i in 1:5){
  for (method in methods){
    session <- paste0(year,i) 
    filter_tidy <-Filter_tidy$new(tidy_table)
    print(session)
    filter_tidy$select_session(session)
    filter_tidy$select_method(method)
    final_structure <- filter_tidy$spatial()
    output_path <- glue::glue("data/{session}_{method}.csv")
    write_csv(final_structure, file = output_path, na = "0")
  }
}