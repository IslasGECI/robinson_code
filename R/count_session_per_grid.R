#' @import dplyr
#' @import readr
#' @import tidyr
#' @import tidyverse
#' @importFrom magrittr %>%

count_session_per_grid <- function(tidy_camera_traps) {
  tidy_camera_traps %>%
    get_cameras_since_october_2021() %>%
    drop_na() %>%
    group_by(Grid) %>%
    summarise(number_session = n_distinct(Session))
}

#' @export
write_session_per_grid <- function(path_config = list("cameras" = "data/raw/robinson_coati_detection_camera_traps/detection_camera_traps.csv", "coordinates" = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv"), output_path = "data/count_of_sessions_per_grid.csv") {
  counted_sessions <- tidy_from_path_camera(path_config) %>%
    count_session_per_grid() %>%
    fill_missing_grids()

  write_csv(counted_sessions, output_path)
}

fill_missing_grids <- function(df_with_missing_grids) {
  all_grids <- tibble(Grid = 1:50, number_session = 0)
  right_join(df_with_missing_grids, all_grids, by = c("Grid")) %>%
    mutate(number_session = number_session.x) %>%
    select(-c("number_session.y", "number_session.x")) %>%
    replace(is.na(.), 0) %>%
    arrange(Grid)
}
