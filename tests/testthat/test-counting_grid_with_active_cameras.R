library(tidyverse)
testthat::describe("Counting active cameras", {
  multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
  it("get_effort_by_grid_and_season_in_long_table 🥈", {
    obtained <- get_effort_by_grid_and_season_in_long_table(multi_data)
    expected <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
  it("Filter inactive cameras", {
    resumed_effort <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    obtained <- drop_grid_without_effort(resumed_effort)
    obtained_rows <- nrow(obtained)
    expected_rows <- 5
    expect_equal(obtained_rows, expected_rows)
  })
  it("count_cells_with_camera_data_by_session", {
    resumed_effort <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    droped_grid <- drop_grid_without_effort(resumed_effort)
    obtained <- count_cells_with_camera_data_by_session(droped_grid)
    expected <- read_csv("../data/filter_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
  it("🪙 ", {
    obtained <- count_cells_with_camera_data_from_multisession_data(multi_data)
    expected <- read_csv("../data/filter_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
})
