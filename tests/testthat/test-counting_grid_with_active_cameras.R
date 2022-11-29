library(tidyverse)
testthat::describe("Counting active cameras", {
  multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
  it("Selecting effort", {
    obtained <- select_effort(multi_data)
    obtained_n_cols <- ncol(obtained)
    expected_n_cols <- 8
    expect_equal(obtained_n_cols, expected_n_cols)
  })
  it("Long table -delete me-", {
    selected_data <- select_effort(multi_data)
    obtained <- get_long_table_for_effort(selected_data)
    obtained_n_rows <- nrow(obtained)
    expected_n_rows <- 9 * 6
    expect_equal(obtained_n_rows, expected_n_rows)
    obtained_n_cols <- ncol(obtained)
    expected_n_cols <- 4
    expect_equal(obtained_n_cols, expected_n_cols)
  })
  it("Sum effort -delete me-", {
    long_table <- multi_data %>% select_effort() %>% get_long_table_for_effort()
    obtained <- effort_by_grid_and_season(long_table)
    expected <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
  it("get_effort_by_grid_and_season_in_long_table -delete me-", {
    obtained <- get_effort_by_grid_and_season_in_long_table(multi_data)
    expected <- read_csv("../data/count_cameras_with_effort_from_multisesion.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
  it("Filter inactive cameras", {

  })
})
