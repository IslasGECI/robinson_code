library(tidyverse)

fill_missing_weeks_with_empty_rows <- function(filtered_tall_table, month) {
  grid <- 49
  missing_rows <- get_tibble_with_grid_ocassion_columns(grid, month)
  return(full_join(filtered_tall_table, missing_rows))
}

get_tibble_with_grid_ocassion_columns <- function(grid, month) {
  limit_weeks <- get_first_last_week_from_month(month)
  missing_rows <- tibble(Grid = grid, Ocassion = limit_weeks[1]:limit_weeks[2])
  return(missing_rows)
}

get_first_last_week_from_month <- function(month) {
  first_day_of_month_string <- paste0("2022-", month, "-01")
  first_day_of_month <- lubridate::ymd(first_day_of_month_string)
  first_week_of_month <- lubridate::isoweek(first_day_of_month)
  last_of_january <- lubridate::ymd("2022-01-31")
  last_day_of_month <- lubridate::add_with_rollback(last_of_january, months(month - 1))
  last_week_of_month <- lubridate::isoweek(last_day_of_month)
  return(c(first_week_of_month, last_week_of_month))
}

#' @export
tidy_2_final <- function(tidy_table) {
  first_month_week <- min(tidy_table$Ocassion)
  tidy_table <- tidy_table %>% mutate(Ocassion = Ocassion - first_month_week + 1)
  final <- tidy_table %>%
    pivot_wider(names_from = Ocassion, values_from = c(r, e))
  return(final)
}
