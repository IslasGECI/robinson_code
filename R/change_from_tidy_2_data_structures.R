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

get_week_of_year_from_date <- function(date){
  year <- lubridate::year(date)
  first_day_of_year_string <- paste0(year, "-01-01")
  first_week_of_year <- lubridate::isoweek(first_day_of_year_string)
  week_of_year <- lubridate::isoweek(date)
  if (first_week_of_year >= 52) {
    week_of_year <- week_of_year + 1
  }
  month_of_year <- lubridate::month(date)
  if ((month_of_year == 1) & (week_of_year >= 52)) {
    week_of_year <- 1
  }
  return(week_of_year)
}

get_first_last_week_from_month <- function(session) {
  first_day_of_month <- paste0(session, "-01")
  first_week_of_month <- get_week_of_year_from_date(first_day_of_month)
  year <- lubridate::year(first_day_of_month)
  last_of_january_string <- paste0(year, "-01-31")
  last_of_january <- lubridate::ymd(last_of_january_string)
  month <- lubridate::month(first_day_of_month)
  last_day_of_month <- lubridate::add_with_rollback(last_of_january, months(month - 1))
  last_week_of_month <- get_week_of_year_from_date(last_day_of_month)
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
