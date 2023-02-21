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
    count_session_per_grid()

  write_csv(counted_sessions, output_path)
}
