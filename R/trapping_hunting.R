library(tidyverse)

get_hunting_effort <- function(raw_trapping_hunting) {
  hunting_effort <- raw_trapping_hunting %>%
    mutate(hunting_effort = Days_on_terrain * Persons_on_terrain)
  return(hunting_effort)
}

get_ocassion <- function(raw_trapping_hunting) {
  ocassions <- raw_trapping_hunting %>%
    mutate(ocassion = lubridate::isoweek(raw_trapping_hunting$Date))
  return(ocassions)
}

get_session <- function(data_trapping_hunting) {
  sessions <- data_trapping_hunting %>%
    mutate(session = lubridate::month(data_trapping_hunting$Date))
  return(sessions)
}

select_columns <- function(data) {
  clean_data <- data %>% select(-c(Sector, Persons_on_terrain))
  return(clean_data)
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

group_by_grid_session_and_ocassion <- function(data) {
  grouped_data <- data %>% group_by(Grid, session, ocassion)
  return(grouped_data)
}
