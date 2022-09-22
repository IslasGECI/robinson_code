library(tidyverse)

#' @export
get_multisession_structures_by_method <- function(path_config) {
  tidy_table <- get_tidy_from_field_and_cameras(path_config)
  methods <- c("Hunting", "Trapping", "Observation", "Camera-Traps")
  years <- 2020:2022
  for (method in methods) {
    multisession_by_method <- get_multiyear_structure_by_method(tidy_table, years, method)
    output_dir <- path_config[["output_path"]]
    output_path <- glue::glue("{output_dir}/{method}.csv")
    write_csv(multisession_by_method, file = output_path, na = "0")
  }
}
get_multiyear_structure_by_method <- function(tidy_table, years, method) {
  multisession_by_method <- tibble(Grid = as.numeric(), Session = "", Method = "", r_1 = as.numeric(), r_2 = as.numeric(), r_3 = as.numeric(), r_4 = as.numeric(), r_5 = as.numeric(), r_6 = as.numeric(), e_1 = as.numeric(), e_2 = as.numeric(), e_3 = as.numeric(), e_4 = as.numeric(), e_5 = as.numeric(), e_6 = as.numeric())
  for (year in years) {
    for (month in 1:12) {
      session <- paste(year, month, sep = "-")
      final_structure <- get_structure_by_session_and_method(tidy_table, session, method)
      multisession_by_method <- plyr::rbind.fill(multisession_by_method, final_structure)
    }
  }
  multisession_by_method <- subset(multisession_by_method, select = -c(Method))
  return(multisession_by_method)
}
get_structure_by_session_and_method <- function(tidy_table, session, method) {
  filter_tidy <- Filter_tidy$new(tidy_table)
  filter_tidy$select_session(session)
  filter_tidy$select_method(method)
  final_structure <- filter_tidy$spatial()
  return(final_structure)
}
fill_missing_weeks_with_empty_rows <- function(filtered_tall_table, month) {
  grid <- as.numeric(NA)
  missing_rows <- get_tibble_with_grid_ocassion_columns(grid, month)
  return(tibble(plyr::rbind.fill(filtered_tall_table, missing_rows)))
}

get_tibble_with_grid_ocassion_columns <- function(grid, month) {
  limit_weeks <- get_first_last_week_from_month(month)
  missing_rows <- tibble(Grid = grid, Ocassion = limit_weeks[1]:limit_weeks[2])
  return(missing_rows)
}

get_first_last_week_from_month <- function(session) {
  first_week_of_month <- get_week_of_year_from_date(get_first_day_of_month(session))
  last_week_of_month <- get_week_of_year_from_date(get_last_day_of_month(session))
  return(c(first_week_of_month, last_week_of_month))
}
get_first_day_of_month <- function(session) {
  first_day_of_month <- paste0(session, "-01")
  return(first_day_of_month)
}
get_last_day_of_month <- function(session) {
  first_day_of_month <- get_first_day_of_month(session)
  year <- lubridate::year(first_day_of_month)
  last_of_january_string <- paste0(year, "-01-31")
  last_of_january <- lubridate::ymd(last_of_january_string)
  month <- lubridate::month(first_day_of_month)
  last_day_of_month <- lubridate::add_with_rollback(last_of_january, months(month - 1))
  return(last_day_of_month)
}

get_week_of_year_from_date <- function(date) {
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
  if ((month_of_year == 12)) {
    if (week_of_year == 1) {
      week_of_year <- 53
    } else if (week_of_year == 2) {
      week_of_year <- 54
    }
  }
  return(week_of_year)
}
