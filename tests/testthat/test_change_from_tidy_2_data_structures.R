library(tidyverse)

describe("We define the expected data structures", {
  path_cameras <- "../data/raw_cameras.csv"
  sigthing_path <- "../data/observations_database_for_tests.csv"
  hunting_path <- "../data/hunting_database_for_tests.csv"
  trapping_path <- "../data/trapping_database_for_tests.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  path_list <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = sigthing_path)
  path_config <- list("cameras" = path_cameras, "field" = path_list, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(path_config)
  session <- "2022-4"
  capturas <- tidy_table %>%
    filter(Session == session) %>%
    group_by(Method) %>%
    summarize(capturas = sum(r))
  it("Expected Camera-Traps data structure", {
    method <- "Camera-Traps"
    final_structure <- Filter_tidy$new(tidy_table)
    final_structure$select_session(session)
    final_structure$select_method(method)
    obtained_final_structure <- final_structure$spatial()
    expected_final_structure <- tibble(
      Grid = c(15, 31, 38),
      Session = rep(session, 3),
      Method = c("Camera-Traps", "Camera-Traps", "Camera-Traps"),
      r_1 = c(NA, NA, 1),
      r_2 = c(1, 0, NA),
      r_3 = as.numeric(NA),
      r_4 = as.numeric(NA),
      r_5 = as.numeric(NA),
      e_1 = c(NA, NA, 1),
      e_2 = c(1, 1, NA),
      e_3 = as.numeric(NA),
      e_4 = as.numeric(NA),
      e_5 = as.numeric(NA),
    )
    expect_equal(obtained_final_structure, expected_final_structure)
    expected_capture <- capturas %>%
      filter(Method == "Camera-Traps") %>%
      .$capturas
    obtained_capture <- sum(sum(obtained_final_structure[, 4:8], na.rm = TRUE))
    expect_equal(obtained_capture, expected_capture)
  })
  it("Expected Hunting data structure", {
    method <- "Hunting"
    final_structure <- Filter_tidy$new(tidy_table)
    session <- "2022-4"
    final_structure$select_session(session)
    final_structure$select_method(method)
    obtained_final_structure <- final_structure$spatial()
    path_expected <- "../data/hunting_final_structure.csv"
    expected_final_structure <- read_csv(path_expected, show_col_types = FALSE, col_types = "nccnnnnnnnnnn")
    expect_equal(obtained_final_structure, expected_final_structure)

    expected_capture <- capturas %>%
      filter(Method == "Hunting") %>%
      .$capturas
    obtained_capture <- sum(sum(obtained_final_structure[, 4:8], na.rm = TRUE))
    expect_equal(obtained_capture, expected_capture)
  })
})
describe("Get limit weeks", {
  it("Get first and final week from April", {
    month <- "2022-4"
    expected_weeks <- c(14, 18)
    obtained_weeks <- get_first_last_week_from_month(month)
    expect_equal(obtained_weeks, expected_weeks)
  })
  it("Get first and final week from May", {
    month <- "2022-5"
    expected_weeks <- c(18, 23)
    obtained_weeks <- get_first_last_week_from_month(month)
    expect_equal(obtained_weeks, expected_weeks)
  })
})
describe("Make join to add missing weeks in a grid", {
  it("For example for grid 49 and month 4", {
    filtered_tall_table <- read_csv("../data/input_april_filtered_tall_hunting.csv", show_col_types = FALSE)
    expected_missing_weeks <- read_csv("../data/output_april_filtered_tall_hunting.csv", show_col_types = FALSE)
    month <- "2022-4"
    obtained_missing_weeks <- fill_missing_weeks_with_empty_rows(filtered_tall_table, month)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
})
describe("get_tibble_with_grid_ocassion_columns return tibble with columns Grid and ocassion", {
  it("For the example grid = 49 and session = 1", {
    grid <- 49
    session <- "2022-1"
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, session)
    expected_missing_weeks <- tibble(Grid = 49, Ocassion = 1:6)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
  it("For the example grid = 49 and session = 2", {
    grid <- 49
    session <- "2022-2"
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, session)
    expected_missing_weeks <- tibble(Grid = 49, Ocassion = 6:10)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
  it("For the example grid = 49 and session = 4", {
    grid <- 49
    month <- "2022-4"
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, month)
    expected_missing_weeks <- tibble(Grid = 49, Ocassion = 14:18)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
  it("For the example grid = 1 and session = 5", {
    grid <- 1
    month <- "2022-5"
    obtained_missing_weeks <- get_tibble_with_grid_ocassion_columns(grid, month)
    expected_missing_weeks <- tibble(Grid = grid, Ocassion = 18:23)
    expect_equal(obtained_missing_weeks, expected_missing_weeks)
  })
})

describe("get_week_of_year_from_date", {
  it("Testing January", {
    expected_week <- 1
    date <- "2007-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2008-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2009-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2010-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2011-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2012-01-01"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
  })
  it("Testing December", {
    expected_week <- 53
    date <- "2007-12-31"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2008-12-31"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2009-12-31"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2010-12-31"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2011-12-31"
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
    date <- "2012-12-31"
    expected_week <- 54
    obtained_week <- get_week_of_year_from_date(date)
    expect_equal(obtained_week, expected_week)
  })
})

describe("test extremes weeks of month",{
  it("test get_first_week_of_month",{
    first_day_of_month <- "2022-4-1"
    obtained_first_week <- get_first_week_of_month(first_day_of_month)
    expected_first_week <- 14
    expect_equal(obtained_first_week, expected_first_week)
  })
  it("test get_last_week_of_month",{
    last_day_of_month <- "2022-4-30"
    obtained_last_week <- get_last_week_of_month(last_day_of_month)
    expected_last_week <- 18
    expect_equal(obtained_last_week, expected_last_week)
  })
})
