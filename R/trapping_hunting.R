library(tidyverse)

get_hunting_effort <- function(raw_trapping_hunting){
  hunting_effort <- raw_trapping_hunting %>% 
      mutate(hunting_effort = Days_on_terrain * Persons_on_terrain)
  return(hunting_effort)
}

get_ocassion <- function(raw_trapping_hunting){
  ocassions <- raw_trapping_hunting %>% 
      mutate(ocassion = lubridate::isoweek(raw_trapping_hunting$Date))
  return(ocassions)
}

get_session <- function(data_trapping_hunting){
  sessions <- data_trapping_hunting %>% 
      mutate(session = lubridate::month(data_trapping_hunting$Date))
  return(sessions)
}
