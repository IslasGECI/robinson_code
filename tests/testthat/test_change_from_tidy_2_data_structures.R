library(tidyverse)

describe("We define the expected data structures", {
  path_cameras <- "../data/raw_cameras.csv"
  path_field <- "../data/input_trapping_hunting.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(paths)
  it("Expected Camera-Traps data structure", {
    method <- "Camera-Traps"
    final_structure <- Filter_tidy$new(tidy_table)
    final_structure$select_session(4)
    final_structure$select_method(method)
    obtained_final_structure <- final_structure$spatial()
    expected_final_structure <- tibble(
      Grid = c(15, 31, 38),
      session = c(4, 4, 4),
      Method = c("Camera-Traps", "Camera-Traps", "Camera-Traps"),
      r_1 = c(NA, NA, 1),
      r_2 = c(1, 0, NA),
      e_1 = c(NA, NA, 1),
      e_2 = c(1, 1, NA)
    )
    expect_equal(obtained_final_structure, expected_final_structure)
  })
  it("Expected Hunting data structure", {
    method <- "Hunting"
    final_structure <- Filter_tidy$new(tidy_table)
    final_structure$select_session(4)
    final_structure$select_method(method)
    obtained_final_structure <- final_structure$spatial()
    path_expected <- "../data/hunting_final_structure.csv"
    expected_final_structure <- read_csv(path_expected, show_col_types = FALSE)
    expect_equal(obtained_final_structure, expected_final_structure)
  })
  it("Get first and final week from April", {
    month <- 4
    expected_weeks <- c(13, 18)
    obtained_weeks <- get_first_last_week_from_month(month)
    expect_equal(obtained_weeks, expected_weeks)
  })
  it("Get first and final week from May", {
    month <- 5
    expected_weeks <- c(18, 22)
    obtained_weeks <- get_first_last_week_from_month(month)
    expect_equal(obtained_weeks, expected_weeks)
  })
})
