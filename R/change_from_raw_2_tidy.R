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

select_date_ocassion_camera_and_detection_columns <- function(data) {
  dates <- as.character(data$DateTime)
  ocassions <- lubridate::isoweek(dates)
  camera_IDs <- as.numeric(gsub(".*?([0-9]+).*", "\\1", data$RelativePath))
  coati_count <- data$CoatiCount
  result <- tibble(
    date = dates,
    Ocassion = ocassions,
    camera_id = camera_IDs,
    coati_count = coati_count
  )
  return(result)
}

count_detection_by_window <- function(filtered_structure) {
  result <- filtered_structure %>%
    add_window_column(method = "static") %>%
    group_by(window, camera_id, Ocassion) %>%
    summarize(coati_count = max(coati_count)) %>%
    mutate(date = substr(window, start = 0, stop = 10)) %>%
    ungroup()
  return(result)
}

add_window_column <- function(filtered_structure, method = "rolling") {
  if (method == "static") {
    return(add_static_window(filtered_structure))
  }
  return(assign_window_number_to_detections(filtered_structure))
}

add_static_window <- function(filtered_structure) {
  result <- filtered_structure %>%
    mutate(window = substr(date, start = 0, stop = 15))
  return(result)
}

assign_window_number_to_detections <- function(selected_columns) {
  with_window_numbers <- selected_columns %>%
    filter_with_coati() %>%
    add_time_difference() %>%
    is_new_window() %>%
    add_window_number()
  return(join_original_with_window_numbers(selected_columns, with_window_numbers))
}
filter_with_coati <- function(selected_columns) {
  return(selected_columns %>% filter(coati_count > 0))
}
add_time_difference <- function(filtered_structure) {
  minute_difference <- as.numeric(ceiling(diff(filtered_structure$date) / 60))
  filtered_structure$time_difference <- c(0, minute_difference)
  return(filtered_structure)
}

is_new_window <- function(output_with_differences) {
  new_window <- output_with_differences %>%
    mutate(is_new_window = time_difference > 10)
  return(new_window)
}
add_window_number <- function(output_is_new_window) {
  return(output_is_new_window %>% mutate(window = cumsum(is_new_window)))
}
join_original_with_window_numbers <- function(original, with_window) {
  columns <- c("date", "camera_id", "window")
  good_table <- with_window %>% select(columns)
  joined <- original %>% left_join(good_table, by = c("date", "camera_id"))
  return(joined)
}



count_detection_by_day <- function(filter_table) {
  filtered_structure <- filter_table %>%
    group_by(camera_id, Ocassion, day = lubridate::day(date), Session = lubridate::month(date)) %>%
    summarize(r = sum(coati_count)) %>%
    ungroup()
  return(filtered_structure)
}


add_effort_and_detection_columns_by_ocassion <- function(grouped_data) {
  group_by_id_ocassion <- grouped_data %>%
    group_by(camera_id, Session, Ocassion) %>%
    summarize(r = sum(r), e = max(day) - min(day) + 1) %>%
    ungroup() %>%
    mutate(Method = "Camera-Traps")
  return(group_by_id_ocassion)
}

replace_camera_id_with_grid_id <- function(tidy_camera, coordinates_path) {
  camera_coordinates <- read_csv(coordinates_path, show_col_types = FALSE)
  tidy_grid <- left_join(tidy_camera, camera_coordinates, by = c("camera_id" = "N camara")) %>%
    select(Grid = `N Cuadricula`, Session, Ocassion, r, e, Method)
  return(tidy_grid)
}

#' @export
tidy_from_path_camera <- function(path) {
  data <- readr::read_csv(path[["cameras"]], show_col_types = FALSE)
  tidy_table <- data %>%
    fill_dates() %>%
    select_date_ocassion_camera_and_detection_columns() %>%
    count_detection_by_window() %>%
    count_detection_by_day() %>%
    add_effort_and_detection_columns_by_ocassion() %>%
    replace_camera_id_with_grid_id(path[["coordinates"]])
  return(tidy_table)
}
