get_prediction <- function(predictions_df, month) {
  selected_data <- predictions_df %>% filter(months == month)
  return(selected_data$ucl)
}

get_max <- function(predictions_df, ignore_month = NULL) {
  selected_data <- predictions_df %>% filter(!(months %in% ignore_month))
  return(max(selected_data$ucl))
}

get_min <- function(predictions_df, ignore_month = NULL) {
  selected_data <- predictions_df %>% filter(!(months %in% ignore_month))
  return(min(selected_data$lcl))
}
