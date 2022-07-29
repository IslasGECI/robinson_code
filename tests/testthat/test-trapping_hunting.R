library(tidyverse)

describe("Get tidy table from trapping and hunting data", {
  path <- "../data/input_trapping_hunting.csv"
  raw_data <- read_csv(path)
  trapping_hunting_data <- get_hunting_effort(raw_data) %>%
    get_ocassion() %>%
    get_session() %>%
    select_columns()
  it("Get hunting effort", {
    obtained_hunting_effort <- trapping_hunting_data$hunting_effort
    expected_hunting_effort <- c(30, 12, 6, 30, 9, 10, 18, 21)
    expect_equal(obtained_hunting_effort, expected_hunting_effort)
  })
  it("Get ocassion", {
    obtained_ocassion <- trapping_hunting_data$ocassion
    expected_ocassion <- c(12, 14, 14, 14, 15, 15, 16, 20)
    expect_equal(obtained_ocassion, expected_ocassion)
  })
  it("Get session", {
    obtained_session <- trapping_hunting_data$session
    expected_session <- c(3, 4, 4, 4, 4, 4, 4, 5)
    expect_equal(obtained_session, expected_session)
  })
  it("Get needed columns", {
    obtained_columns <- colnames(trapping_hunting_data)
    expected_columns <- c("Date", "Grid", "Days_on_terrain", "Hunted_Coati", "Night-traps", "Captured_Coati", "Observed_Coati", "hunting_effort", "ocassion", "session")
    expect_equal(obtained_columns, expected_columns)
  })
  expect_equal_column <- function(grouped_data, column_name, expected_column) {
    obtained_column <- grouped_data[[column_name]]
    expect_equal(obtained_column, expected_column)
  }
  it("Group by grid and ocassion", {
    grouped_data <- get_removal_and_effort_trapping(trapping_hunting_data)
    expected_trapping_removed_grouped_data <- c(0, 0, 2, 2, 0, 0, 0)
    expect_equal_column(grouped_data, "r", expected_trapping_removed_grouped_data)
    expected_trapping_effort_grouped_data <- c(5, 0, 1, 5, 8, 8, 4)
    expect_equal_column(grouped_data, "e", expected_trapping_effort_grouped_data)

    grouped_data <- get_removal_and_effort_hunting(trapping_hunting_data)
    expected_hunting_effort_grouped_data <- c(21, 10, 18, 18, 30, 30, 9)
    expect_equal_column(grouped_data, "e", expected_hunting_effort_grouped_data)
    expected_hunting_method_grouped_data <- rep("Hunting", 7)
    expect_equal_column(grouped_data, "Method", expected_hunting_method_grouped_data)

    grouped_data <- get_detection_and_effort_observation(trapping_hunting_data)
    expected_observation_effort_grouped_data <- c(21, 10, 18, 18, 30, 30, 9)
    expect_equal_column(grouped_data, "e", expected_observation_effort_grouped_data)
    expected_observation_detection_grouped_data <- c(0, 0, 3, 0, 0, 0, 0)
    expect_equal_column(grouped_data, "r", expected_observation_detection_grouped_data)
    expected_observation_method_grouped_data <- rep("Observation", 7)
    expect_equal_column(grouped_data, "Method", expected_observation_method_grouped_data)
  })
  expect_equal_tidy_table <- function(tidy_file_path, tidy_from_path_method) {
    expected_tidy <- read_csv(tidy_file_path)
    obtained_tidy <- tidy_from_path_method(path)
    expect_equal(obtained_tidy, expected_tidy)
  }
  it("Test tidy table for trapping", {
    tidy_file_path <- "../data/tidy_trapping.csv"
    expect_equal_tidy_table(tidy_file_path, tidy_from_path_trapping)
  })
  it("Test tidy table for hunting", {
    tidy_file_path <- "../data/tidy_hunting.csv"
    expect_equal_tidy_table(tidy_file_path, tidy_from_path_hunting)
  })
  it("Concatenate tidy tables", {
    tidy_field_path <- "../data/tidy_from_field.csv"
    expected_tidy_table_from_field <- read_csv(tidy_field_path)
    obtained_tidy_table_from_field <- tidy_from_path_field(path)
    expect_equal(obtained_tidy_table_from_field, expected_tidy_table_from_field)
  })
})