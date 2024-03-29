library(tidyverse)

#' @export
write_prediction_and_cells_with_camera_data <- function(path_predictions, multisession_data_path, output_path = "/workdir/prediction_with_count_cells.csv") {
  predictions <- read_csv(path_predictions, show_col_types = FALSE)
  cells_with_camera_data <- read_csv(multisession_data_path, show_col_types = FALSE) %>%
    count_cells_with_camera_data_from_multisession_data()
  joined_table <- join_prediction_and_cells_with_camera_data(predictions, cells_with_camera_data)
  table_with_months <- add_month_names(joined_table)
  write_csv(table_with_months, output_path)
}
join_prediction_and_cells_with_camera_data <- function(predictions, cell_counts_with_data) {
  result <- left_join(predictions, cell_counts_with_data, by = c(".season" = "session"))
  result <- result %>% mutate(percentage_of_cells_with_camera_data = 100 * cells_with_camera_data / 50)
}

count_cells_with_camera_data_from_multisession_data <- function(multi_data) {
  multi_data %>%
    get_effort_by_grid_and_season_in_long_table() %>%
    drop_grid_without_effort() %>%
    count_cells_with_camera_data_by_session()
}
get_effort_by_grid_and_season_in_long_table <- function(multi_data) {
  multi_data %>%
    select_effort() %>%
    get_long_table_for_effort() %>%
    effort_by_grid_and_season()
}
drop_grid_without_effort <- function(resumed_effort) {
  resumed_effort %>%
    filter(e != 0)
}
count_cells_with_camera_data_by_session <- function(grids_with_data) {
  grids_with_data %>%
    group_by(session) %>%
    summarize(cells_with_camera_data = n()) %>%
    ungroup()
}

select_effort <- function(multi_data) {
  result <- multi_data %>% select(-starts_with("r"))
  return(result)
}
get_long_table_for_effort <- function(selected_effort) {
  result <- selected_effort %>%
    pivot_longer(cols = starts_with("e_"), names_to = "week", names_prefix = "e_", values_to = "e")
  return(result)
}
effort_by_grid_and_season <- function(long_table) {
  result <- long_table %>%
    group_by(session, Grid) %>%
    summarize(e = sum(e)) %>%
    ungroup() %>%
    select(Grid, session, e)
  return(result)
}
