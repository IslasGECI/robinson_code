library(tidyverse)
testthat::describe("Counting active cameras", {
  it("Selecting effort", {
    multi_data <- read_csv("../data/multisesion_camera_traps_cats.csv", show_col_types = FALSE)
    obtained <- select_effort(multi_data)
    obtained_n_cols <- ncol(obtained)
    expected_n_cols <- 8
    expect_equal(obtained_n_cols, expected_n_cols)
  })
  it("Filter inactive cameras", {

  })
})
