camera_traps_2_ramsey_format <- function(camera_sightings) {
  camera_data <- Filter_Camera_by_Month$new(camera_sightings)
  filtered_data <- camera_data$filter_data_for_multisession()
  multisession <- Multisession$new(filtered_data)
  ramsey_format_data <- multisession$data_for_multisession %>% rename(session = Session)
  return(ramsey_format_data)
}
