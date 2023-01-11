get_prediction <- function(predictions_df, month){
  selected_data <- predictions_df %>% filter(months==month)
  return(selected_data$ucl)
}
