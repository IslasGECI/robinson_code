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
methods <- c("Hunting", "Trapping", "Observation", "Camera-Traps")

for (method in methods){
  multisession_by_method <- tibble(Grid = as.numeric(), Session = "", Method = "", r_1 = as.numeric(), r_2 = as.numeric(), r_3 = as.numeric(), r_4 = as.numeric(), r_5 = as.numeric(), r_6 = as.numeric(),e_1 = as.numeric(), e_2 = as.numeric(), e_3 = as.numeric(), e_4 = as.numeric(), e_5 = as.numeric(), e_6 = as.numeric())
  for (year in 2020:2022){
    for (i in 1:12){
      session <- paste(year,i,sep = "-")
      filter_tidy <-Filter_tidy$new(tidy_table)
      filter_tidy$select_session(session)
      filter_tidy$select_method(method)
      final_structure <- filter_tidy$spatial()
      multisession_by_method <- plyr::rbind.fill(multisession_by_method, final_structure)
    }
  }
  output_path <- glue::glue("data/{method}.csv")
  multisession_by_method <- subset(multisession_by_method, select=-c(Method))
  write_csv(multisession_by_method, file = output_path, na = "0")
}
