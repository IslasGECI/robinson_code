library(tidyverse)

tidy_from_path_observation <- function(path_config) {
  workdir_path <- getwd()
  sighting_path <- paste0(workdir_path, "/sighting.csv")
  write_csv(concatenate_observations_from_trapping_and_hunting(path_config), sighting_path)
  tidy_from_path_by_method(sighting_path, get_detection_and_effort_observation)
}
tidy_from_path_hunting <- function(path) {
  tidy_from_path_by_method(path, get_removal_and_effort_hunting)
}
tidy_from_path_trapping <- function(path) {
  tidy_from_path_by_method(path, get_removal_and_effort_trapping)
}

tidy_from_path_by_method <- function(path, get_removal_and_effort_method) {
  raw_data <- read_csv(path, show_col_types = FALSE)
  trapping_hunting_data <- get_person_day_effort(raw_data) %>%
    get_ocassion() %>%
    get_session() %>%
    select_columns()
  tidy_trapping <- get_removal_and_effort_method(trapping_hunting_data)
  return(tidy_trapping)
}

get_detection_and_effort_observation <- function(data) {
  get_removal_and_effort_by_method(data, `Observed_Coati`, `Person_day_effort`, "Observation")
}
get_removal_and_effort_hunting <- function(data) {
  get_removal_and_effort_by_method(data, `Hunted_Coati`, `Person_day_effort`, "Hunting")
}
get_removal_and_effort_trapping <- function(data) {
  get_removal_and_effort_by_method(data, `Captured_Coati`, `Night-traps`, "Trapping")
}
get_removal_and_effort_by_method <- function(data, removed, effort, method) {
  grouped_data <- data %>%
    group_by_grid_session_and_ocassion() %>%
    summarize(r = sum({{ removed }}, na.rm = TRUE), e = sum({{ effort }}, na.rm = TRUE)) %>%
    ungroup() %>%
    mutate(Method = method)
  return(grouped_data)
}


get_ocassion <- function(raw_trapping_hunting) {
  ocassions <- sapply(raw_trapping_hunting$Date, get_week_of_year_from_date)
  trapping_hunting_with_ocassions <- raw_trapping_hunting %>%
    mutate(Ocassion = ocassions)
  return(trapping_hunting_with_ocassions)
}

get_session <- function(data_trapping_hunting) {
  months <- lubridate::month(data_trapping_hunting$Date)
  years <- lubridate::year(data_trapping_hunting$Date)
  sessions <- data_trapping_hunting %>%
    mutate(Session = paste(years, months, sep = "-"))
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
tidy_from_path_field <- function(path_config) {
  tidy_trapping <- tidy_from_path_trapping(path_config[["trapping"]])
  tidy_hunting <- tidy_from_path_hunting(path_config[["hunting"]])
  tidy_observation <- tidy_from_path_observation(path_config)
  return(full_join(tidy_hunting, tidy_trapping) %>% full_join(tidy_observation))
}

get_tidy_from_field_and_cameras <- function(path_config) {
  tidy_field <- tidy_from_path_field(path_config)
  tidy_camera <- tidy_from_path_camera(path_config)
  return(rbind(tidy_field, tidy_camera))
}
