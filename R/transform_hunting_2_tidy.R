library(tidyverse)

get_person_day_effort <- function(raw_trapping_hunting) {
  person_day_effort <- raw_trapping_hunting %>%
    mutate(Person_day_effort = Days_on_terrain * Persons_on_terrain)
  return(person_day_effort)
}
