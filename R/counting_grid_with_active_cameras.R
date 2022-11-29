library(tidyverse)

select_effort <- function(multi_data) {
  result <- multi_data %>% select(-starts_with("r"))
  return(result)
}

get_long_table_for_effort <- function(selected_effort) {
  result <- selected_effort %>%
    pivot_longer(cols = starts_with("e_"), names_to = "week", names_prefix = "e_", values_to = "e")
  return(result)
}

effort_by_grid_and_season <- function(long_table) {
    result <- long_table %>%
      group_by(session, Grid) %>%
      summarize(e = sum(e)) %>%
      ungroup() %>%
      select(Grid, session, e)
    return(result)
}
