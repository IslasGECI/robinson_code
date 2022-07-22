library(tidyverse)

get_initial_and_delta_day_by_camera <- function(raw_data){
  limit_days_by_camera <- raw_data %>% 
    mutate(day = lubridate::as_date(DateTime)) %>% 
    group_by(RelativePath) %>% 
    summarize(last_day = max(day), initial_day = min(day), delta_day = lubridate::mday(last_day) - lubridate::mday(initial_day))
  return(limit_days_by_camera)
}

unamed_function <- function(limit_days_by_camera){
  renglon <- tibble(RelativePath = limit_days_by_camera$RelativePath, 
  coati_count = 0, DateTime = limit_days_by_camera$initial_day + days(0:limit_days_by_camera$delta_day))
  for (i in 0:nrow(limit_days_by_camera)){print(limit_days_by_camera$RelativePath[i])}
  return(renglon)
}

fill_days <- function(raw_data){
  return(raw_data)
}

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


group_data_by_window <- function(filtered_structure) {
  result <- filtered_structure %>%
    mutate(window = substr(date, start = 0, stop = 15)) %>%
    group_by(window, camera_id, ocassion) %>%
    summarize(coati_count = max(coati_count)) %>%
    mutate(date = substr(window, start = 0, stop = 10)) %>%
    ungroup()
  return(result)
}


group_filtered_data <- function(filter_table) {
  filtered_structure <- filter_table %>%
    group_by(camera_id, ocassion, day = lubridate::day(date)) %>%
    summarize(r = sum(coati_count)) %>%
    mutate(e = 1, method = "Camera-Traps") %>%
    ungroup()
  return(filtered_structure)
}


calculate_effort <- function(grouped_data) {
  group_by_id_ocassion <- grouped_data %>%
    group_by(camera_id, ocassion) %>%
    summarize(r = sum(r), e = max(day) - min(day) + 1) %>%
    ungroup() %>%
    mutate(method = "Camera-Traps")
  return(group_by_id_ocassion)
}

#' @export
tidy_from_path <- function(path) {
  data <- readr::read_csv(path)
  filtered_structure <- filter_raw_data(data)
  capture_by_window <- group_data_by_window(filtered_structure)
  obtained_grouped <- group_filtered_data(capture_by_window)
  obtained_effort <- calculate_effort(obtained_grouped)
  return(obtained_effort)
}
