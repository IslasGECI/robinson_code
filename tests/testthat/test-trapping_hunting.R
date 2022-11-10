library(tidyverse)

testthat::describe("Get tidy table from trapping and hunting data", {
  sigthing_path <- "../data/observations_database_for_tests.csv"
  hunting_path <- "../data/hunting_database_for_tests.csv"
  trapping_path <- "../data/trapping_database_for_tests.csv"
  path_config <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = sigthing_path, "cameras" = "../data/raw_cameras_with_detection.csv", "coordinates" = "../data/camera_traps_coordinates.csv")
  expect_equal_column <- function(grouped_data, column_name, expected_column) {
    obtained_column <- grouped_data[[column_name]]
    expect_equal(obtained_column, expected_column)
  }
  it("test get_removal_and_effort_trapping", {
    trapping_data <- read_csv("../data/input_get_removal_and_effort_trapping.csv", show_col_types = FALSE)
    grouped_data <- get_removal_and_effort_trapping(trapping_data)
    expected_trapping_removed_grouped_data <- c(0, 0, 1, 0, 2, 0, 0)
    expect_equal_column(grouped_data, "r", expected_trapping_removed_grouped_data)
    expected_trapping_effort_grouped_data <- c(5, 1, 2, 4, 5, 8, 8)
    expect_equal_column(grouped_data, "e", expected_trapping_effort_grouped_data)
  })
  it("test get_removal_and_effort_hunting", {
    hunting_data <- read_csv("../data/input_get_removal_and_effort_hunting.csv", show_col_types = FALSE)
    grouped_data <- get_removal_and_effort_hunting(hunting_data)
    expected_hunting_effort_grouped_data <- c(21, 12, 2, 2, 5, 36, 2)
    expect_equal_column(grouped_data, "e", expected_hunting_effort_grouped_data)
    expected_hunting_method_grouped_data <- rep("Hunting", 7)
    expect_equal_column(grouped_data, "Method", expected_hunting_method_grouped_data)
  })
  it("test get_removal_and_effort_observation", {
    sighting_data <- read_csv("../data/input_get_removal_and_effort_sighting.csv", show_col_types = FALSE)
    grouped_data <- get_detection_and_effort_observation(sighting_data)
    expected_observation_effort_grouped_data <- c(2, 2, 2, 2, 4, 2, 2, 2, 2)
    expect_equal_column(grouped_data, "e", expected_observation_effort_grouped_data)
    expected_observation_detection_grouped_data <- c(1, 1, 10, 5, 33, 1, 5, 2, 8)
    expect_equal_column(grouped_data, "r", expected_observation_detection_grouped_data)
    expected_observation_method_grouped_data <- rep("Observation", 9)
    expect_equal_column(grouped_data, "Method", expected_observation_method_grouped_data)
  })
  expect_equal_tidy_table <- function(raw_method_path, tidy_file_path, tidy_from_path_method) {
    expected_tidy <- read_csv(tidy_file_path, show_col_types = FALSE)
    obtained_tidy <- tidy_from_path_method(raw_method_path)
    expect_equal(obtained_tidy, expected_tidy)
  }
  it("Test tidy table for trapping", {
    tidy_file_path <- "../data/test_tidy_for_trapping.csv"
    expect_equal_tidy_table(trapping_path, tidy_file_path, tidy_from_path_trapping)
  })
  it("Test tidy table for hunting", {
    tidy_file_path <- "../data/test_tidy_for_hunting.csv"
    expect_equal_tidy_table(hunting_path, tidy_file_path, tidy_from_path_hunting)
  })
  it("Concatenate tidy tables", {
    tidy_field_path <- "../data/tidy_from_field.csv"
    expected_tidy_table_from_field <- read_csv(tidy_field_path, show_col_types = FALSE)
    obtained_tidy_table_from_field <- tidy_from_path_field(path_config)
    expect_equal(obtained_tidy_table_from_field, expected_tidy_table_from_field)
  })
  it("Concatenate camera traps and field tidy tables", {
    obtained_tidy_four_methods <- get_tidy_from_field_and_cameras(path_config)
    tidy_four_methods_path <- "../data/tidy_four_methods.csv"
    expected_tidy_four_methods <- read_csv(tidy_four_methods_path, show_col_types = FALSE)
    expect_equal(obtained_tidy_four_methods, expected_tidy_four_methods)
  })
})
