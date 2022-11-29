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

testthat::describe("Join predictions and cells with camera data", {
  it("join_prediction_and_cells_with_camera_data", {
    predictions <- read_csv("../data/preds_1km_grid-cats.csv", show_col_types = FALSE)
    cells_with_camera_data <- read_csv("../data/filter_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    obtained <- join_prediction_and_cells_with_camera_data(predictions, cells_with_camera_data)
    expected <- read_csv("../data/preds_1km_grid-cats_with_number_of_cells.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
})