library(tidyverse)

#' @export
filter_raw_data <- function(data) {
  dates <- as.character(data$DateTime)
  ocassions <- lubridate::isoweek(dates)
  camera_IDs <- as.numeric(gsub(".*?([0-9]+).*", "\\1", data$RelativePath))
  coati_count <- data$CoatiCount
  result <- tibble(
    date = dates,
    ocassion = ocassions,
    camera_id = camera_IDs,
    coati_count = coati_count
  )
  return(result)
}

#' @export
group_filtered_data <- function(ocassion_structure) {
  filtered_structure <- ocassion_structure %>%
      group_by(camera_id, ocassion, day = lubridate::day(date)) %>%
      summarize(r = sum(coati_count)) %>%
      mutate(e = 1, method = "Camera-Traps") 
  n_rows = nrow(filtered_structure)
  tidy_structure <- tibble(
      camera_id = filtered_structure$camera_id,
      ocassion = filtered_structure$ocassion,
      r = filtered_structure$r,
      e = rep(1, n_rows),
      method = rep("Camera-Traps",n_rows)
    )
  return(tidy_structure)
}

xxocassion_2_tidy <- function(ocassion_structure) {
  filtered_structure <- ocassion_structure %>%
      group_by(camera_id, ocassion, day = lubridate::day(date)) %>%
      summarize(r = sum(coati_count)) %>%
      mutate(e = 1, method = "Camera-Traps") 
  return(filtered_structure)
}
calculate_effort <- function(raw_table) {
  tidy_table <- group_filtered_data(raw_table)
  tidy_with_effort <- tidy_table %>% group_by() %>% cuenta
  return(tidy_with_effort)  
}
