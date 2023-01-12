get_prediction <- function(predictions_df, month) {
  selected_data <- predictions_df %>% filter(months == month)
  return(selected_data$ucl)
}

get_max <- function(predictions_df, ignore_month = NULL) {
  get_statistic(predictions_df, ignore_month, `ucl`, max)
}

get_min <- function(predictions_df, ignore_month = NULL) {
  get_statistic(predictions_df, ignore_month, `lcl`, min)
}

get_median <- function(predictions_df, ignore_month = NULL) {
  get_statistic(predictions_df, ignore_month, `N`, median)
}

ignoring_months <- function(predictions_df, ignore_month) {
  predictions_df %>% filter(!(months %in% ignore_month))
}

get_statistic <- function(data, ignore_month, column, statistic) {
  selected_data <- ignoring_months(data, ignore_month) %>%
    summarize(computed_statistics = statistic({{ column }}))
  return(selected_data$computed_statistics)
}
get_start_date <- function(predictions_df) {
  return(first(predictions_df$months))
}
get_end_date <- function(predictions_df) {
  return(last(predictions_df$months))
}

get_start_date_es <- function(predictions_df) {
  first_date <- lubridate::my(get_start_date(predictions_df))
  month_number <- lubridate::month(first_date)
  month_in_spanish <- replace_number_with_spanish_name(month_number)
  year <- lubridate::year(first_date)
  add_month_in_spanish_and_year(month_in_spanish, year)
}
get_end_date_es <- function(predictions_df) {
  end_date <- lubridate::my(get_end_date(predictions_df))
  month_number <- lubridate::month(end_date)
  month_in_spanish <- replace_number_with_spanish_name(month_number)
  year <- lubridate::year(end_date)
  add_month_in_spanish_and_year(month_in_spanish, year)
}
