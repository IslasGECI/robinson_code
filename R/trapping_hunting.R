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

group_by_grid_and_ocassion_hunting <- function(data){
  grouped_data <- data %>% group_by(Grid, session, ocassion) %>% 
      summarize(r = sum(Hunted_Coati), e = sum(hunting_effort)) %>% 
      ungroup() %>% 
      mutate(Method = "Hunting")
  return(grouped_data)
}

group_by_grid_and_ocassion_trapping <- function(data){
  grouped_data <- data %>% group_by(Grid, session, ocassion) %>% 
      summarize(r = sum(Captured_Coati), e = sum(`Night-traps`)) %>% 
      ungroup() %>% 
      mutate(Method = "Trapping")
  return(grouped_data)
}