fill_months <- function(number_of_sessions, initial_month = "2021-10") {
  month_range <- get_month_range(number_of_sessions, initial_month)
  string_range <- format(month_range, "%B %Y")
  return(string_range)
}

get_month_range <- function(number_of_sessions, initial_month) {
  start_month <- lubridate::ym(initial_month)
  month_range <- start_month + months(1:number_of_sessions - 1)
  return(month_range)
}

add_month_names <- function(original_table) {
  number_of_sessions <- nrow(original_table)
  month_names <- fill_months(number_of_sessions)
  return(original_table %>% mutate(months = month_names))
}

replace_number_with_spanish_name <- function(month_number) {
  months_in_spanish <- c("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")
  return(months_in_spanish[month_number])
}

add_month_in_spanish_and_year <- function(month_in_spanish, year) {
  return(glue::glue("{month_in_spanish} de {year}"))
}
