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
describe("Make join to add missing weeks in a grid", {
  it("For example for grid 49 and month 4", {
    filtered_tall_table <- read_csv("../data/input_april_filtered_tall_hunting.csv")
    expected_missing_weeks <- read_csv("../data/output_april_filtered_tall_hunting.csv")
    month <- 4
    obtained_missing_weeks <- fill_missing_weeks_with_empty_rows(filtered_tall_table, month)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
})
describe("get_tibble_with_grid_ocassion_columns return tibble with columns Grid and ocassion", {
  it("For the example grid = 49 and session = 4", {
    grid <- 49
    month <- 4
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, month)
    expected_missing_weeks <- tibble(Grid = 49, ocassion = 13:18)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
  it("For the example grid = 1 and session = 5", {
    grid <- 1
    month <- 5
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, month)
    expected_missing_weeks <- tibble(Grid = grid, ocassion = 18:22)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
})
