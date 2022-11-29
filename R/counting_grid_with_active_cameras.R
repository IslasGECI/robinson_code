library(tidyverse)

select_effort <- function(multi_data) {
  result <- multi_data %>% select(-starts_with("r"))
  return(result)
}

get_long_table_for_effort <- function(selected_effort) {
  result <- selected_effort %>%
    pivot_longer(cols = starts_with("e_"), names_to = "week", names_prefix = "e_", values_to = "e")
  print(result)
  return(result)
}
