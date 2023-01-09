fill_months <- function(number_of_sessions, initial_month = "2021-10") {
  start_month <- lubridate::ym(initial_month)
  month_range <- start_month + months(1:number_of_sessions - 1)
  string_range <- format(month_range, "%B %Y")
  return(string_range)
}
add_month_names <- function(original_table) {
  number_of_sessions <- nrow(original_table)
  month_names <- fill_months(number_of_sessions)
  return(original_table %>% mutate(months = month_names))
}
