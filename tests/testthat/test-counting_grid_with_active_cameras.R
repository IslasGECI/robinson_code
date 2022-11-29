library(tidyverse)

testthat::describe("Counting active cameras", {
  multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
  it("🪙 count_cells_with_camera_data_from_multisession_data", {
    obtained <- count_cells_with_camera_data_from_multisession_data(multi_data)
    expected <- read_csv("../data/filter_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
  it("get_effort_by_grid_and_season_in_long_table 🥈", {
    obtained <- get_effort_by_grid_and_season_in_long_table(multi_data)
    expected <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
})

exist_predictions_with_cameras_data <- function(path) {
  file.exists(path)
}
delete_predictions_with_cameras_data <- function(path) {
  if (exist_predictions_with_cameras_data(path)) {
    file.remove(path)
  }
}

testthat::describe("Test write_prediction_and_cells_with_camera_data", {
  it("File exist", {
    output_path <- "/workdir/prediction_with_count_cells.csv"
    delete_predictions_with_cameras_data(output_path)
    path_predictions <- "../data/preds_1km_grid-cats.csv"
    path_multisession_camera_data <- "../data/multisesion_camera_traps_cats.csv"
    write_prediction_and_cells_with_camera_data(path_predictions, path_multisession_camera_data)
    expect_true(exist_predictions_with_cameras_data(output_path))
    expected_table <- read_csv("../data/preds_1km_grid-cats_with_number_of_cells.csv", show_col_types = FALSE)
    obtained_table <- read_csv(output_path, show_col_types = FALSE)
    expect_equal(obtained_table, expected_table)
  })
})
