library(tidyverse)

get_initial_and_delta_day_by_camera <- function(raw_data) {
  limit_days_by_camera <- raw_data %>%
    mutate(day = lubridate::as_date(DateTime)) %>%
    group_by(RelativePath) %>%
    summarize(last_day = max(day), initial_day = min(day), delta_day = lubridate::mday(last_day) - lubridate::mday(initial_day))
  return(limit_days_by_camera)
}

get_missing_rows_with_date_by_camera <- function(limit_days_by_camera) {
  missing_rows <- tibble(RelativePath = c(), DateTime = c(), CoatiCount = c())
  for (i in 1:nrow(limit_days_by_camera)) {
    rows_by_camera <- tibble(
      RelativePath = limit_days_by_camera$RelativePath[i],
      DateTime = limit_days_by_camera$initial_day[i] + lubridate::days(0:limit_days_by_camera$delta_day[i]), CoatiCount = 0
    )
    missing_rows <- bind_rows(missing_rows, rows_by_camera)
  }
  return(missing_rows)
}

fill_dates <- function(raw_data) {
  limit_days_by_camera <- get_initial_and_delta_day_by_camera(raw_data)
  missing_rows <- get_missing_rows_with_date_by_camera(limit_days_by_camera)
  return(bind_rows(raw_data, missing_rows))
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
    mutate(method = "Camera-Traps", session = 4)
  return(group_by_id_ocassion)
}

#' @export
tidy_from_path <- function(path) {
  data <- readr::read_csv(path)
  filled_data <- fill_dates(data)
  filtered_structure <- filter_raw_data(filled_data)
  capture_by_window <- group_data_by_window(filtered_structure)
  obtained_grouped <- group_filtered_data(capture_by_window)
  obtained_effort <- calculate_effort(obtained_grouped)
  return(obtained_effort)
}