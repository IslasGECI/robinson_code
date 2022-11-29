library(tidyverse)
testthat::describe("Counting active cameras", {
  it("Selecting effort", {
    multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
    obtained <- select_effort(multi_data)
    obtained_n_cols <- ncol(obtained)
    expected_n_cols <- 8
    expect_equal(obtained_n_cols, expected_n_cols)
  })
  it("Long table -delete me-", {
    multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
    selected_data <- select_effort(multi_data)
    obtained <- get_long_table_for_effort(selected_data)
    obtained_n_rows <- nrow(obtained)
    expected_n_rows <- 9 * 6
    expect_equal(obtained_n_rows, expected_n_rows)
    obtained_n_cols <- ncol(obtained)
    expected_n_cols <- 4
    expect_equal(obtained_n_cols, expected_n_cols)
  })
  it("Filter inactive cameras", {

  })
})
