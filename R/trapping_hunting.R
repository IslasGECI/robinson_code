library(tidyverse)

tidy_from_path_observation <- function(path) {
  tidy_from_path_by_method(path, get_detection_and_effort_observation)
}
tidy_from_path_hunting <- function(path) {
  tidy_from_path_by_method(path, get_removal_and_effort_hunting)
}
tidy_from_path_trapping <- function(path) {
  tidy_from_path_by_method(path, get_removal_and_effort_trapping)
}

tidy_from_path_by_method <- function(path, get_removal_and_effort_method) {
  raw_data <- read_csv(path, show_col_types = FALSE)
  trapping_hunting_data <- get_hunting_effort(raw_data) %>%
    get_ocassion() %>%
    get_session_and_year() %>%
    select_columns()
  tidy_trapping <- get_removal_and_effort_method(trapping_hunting_data)
  return(tidy_trapping)
}

get_detection_and_effort_observation <- function(data) {
  get_removal_and_effort_by_method(data, `Observed_Coati`, `hunting_effort`, "Observation")
}
get_removal_and_effort_hunting <- function(data) {
  get_removal_and_effort_by_method(data, `Hunted_Coati`, `hunting_effort`, "Hunting")
}
get_removal_and_effort_trapping <- function(data) {
  get_removal_and_effort_by_method(data, `Captured_Coati`, `Night-traps`, "Trapping")
}
get_removal_and_effort_by_method <- function(data, removed, effort, method) {
  grouped_data <- data %>%
    group_by_grid_session_and_ocassion() %>%
    summarize(r = sum({{ removed }}), e = sum({{ effort }})) %>%
    ungroup() %>%
    mutate(Method = method)
  return(grouped_data)
}


get_ocassion <- function(raw_trapping_hunting) {
  ocassions <- raw_trapping_hunting %>%
    mutate(Ocassion = lubridate::isoweek(raw_trapping_hunting$Date))
  return(ocassions)
}

get_session_and_year <- function(data_trapping_hunting) {
  months <- lubridate::month(data_trapping_hunting$Date)
  years <- lubridate::year(data_trapping_hunting$Date)
  sessions <- data_trapping_hunting %>%
    mutate(Session = paste(years,months, sep="-"))
  return(sessions)
}
get_session <- function(data_trapping_hunting) {
  sessions <- data_trapping_hunting %>%
    mutate(Session = lubridate::month(data_trapping_hunting$Date))
  return(sessions)
}

select_columns <- function(data) {
  clean_data <- data %>% select(-c(Sector, Persons_on_terrain))
  return(clean_data)
}

group_by_grid_session_and_ocassion <- function(data) {
  grouped_data <- data %>% group_by(Grid, Session, Ocassion)
  return(grouped_data)
}
tidy_from_path_field <- function(path) {
  tidy_trapping <- tidy_from_path_trapping(path)
  tidy_hunting <- tidy_from_path_hunting(path)
  tidy_observation <- tidy_from_path_observation(path)
  return(full_join(tidy_hunting, tidy_trapping) %>% full_join(tidy_observation))
}

#' @export
get_tidy_from_field_and_cameras <- function(paths) {
  tidy_field <- tidy_from_path_field(paths[["field"]])
  tidy_camera <- tidy_from_path_camera(paths)
  return(rbind(tidy_field, tidy_camera))
}
