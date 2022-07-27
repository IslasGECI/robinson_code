library(tidyverse)

get_hunting_effort <- function(raw_trapping_hunting){
  hunting_effort <- raw_trapping_hunting %>% 
      mutate(hunting_effort = Days_on_terrain * Persons_on_terrain)
  return(hunting_effort)
}
