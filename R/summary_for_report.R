get_prediction <- function(predictions_df, month) {
  selected_data <- predictions_df %>% filter(months == month)
  return(selected_data$ucl)
}
get_prediction_date <- function(predictions_df, ignore_month = NULL) {
  last_month <- predictions_df %>%
    ignoring_months(ignore_month) %>%
    .$months %>%
    last()
  return(last_month)
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
  get_date_limits(predictions_df, get_start_date)
}
get_end_date_es <- function(predictions_df) {
  get_date_limits(predictions_df, get_end_date)
}
get_date_limits <- function(predictions_df, limit) {
  date <- lubridate::my(limit(predictions_df))
  month_number <- lubridate::month(date)
  month_in_spanish <- replace_number_with_spanish_name(month_number)
  year <- lubridate::year(date)
  add_month_in_spanish_and_year(month_in_spanish, year)
}

concatenate_summary_for_report <- function(predictions_df, ignore_month = NULL) {
  prediction_date <- get_prediction_date(predictions_df, ignore_month)
  list(
    "prediction" = get_prediction(predictions_df, prediction_date),
    "max" = get_max(predictions_df, ignore_month),
    "min" = get_min(predictions_df, ignore_month),
    "median" = get_median(predictions_df, ignore_month),
    "start_date" = get_start_date(predictions_df),
    "end_date" = get_end_date(predictions_df),
    "fecha_inicio" = get_start_date_es(predictions_df),
    "fecha_fin" = get_end_date_es(predictions_df),
    "prediction_date" = prediction_date
  )
}
