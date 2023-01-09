fill_months <- function(number_of_sessions, initial_month = "2021-10") {
  start_month <- lubridate::ym(initial_month)
  month_range <- start_month + months(1:number_of_sessions - 1)
  string_range <- format(month_range, "%B %Y")
  return(string_range)
}
