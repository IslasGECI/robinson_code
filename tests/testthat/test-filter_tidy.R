library(tidyverse)

describe("Test tidy filters", {
  path_cameras <- "../data/raw_cameras.csv"
  sigthing_path <- "../data/observations_database_for_tests.csv"
  hunting_path <- "../data/hunting_database_for_tests.csv"
  trapping_path <- "../data/trapping_database_for_tests.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  path_config <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = sigthing_path, "cameras" = path_cameras, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(path_config)
  it("Session returns same number", {
    final_structure <- Filter_tidy$new(tidy_table)
    session <- "2022-3"
    final_structure$select_session(session)
    obtained_session <- final_structure$aux$Session
    expected_session <- rep(session, 3)
    expect_equal(obtained_session, expected_session)
  })
  it("Filter by method", {
    method <- "Camera-Traps"
    final_structure <- Filter_tidy$new(tidy_table)
    obtained_table <- final_structure$select_method(method)
    obtained_method <- obtained_table$Method
    expected_method <- rep("Camera-Traps", 3)
    expect_equal(obtained_method, expected_method)
  })
  it("Filter both, session first", {
    method <- "Hunting"
    session <- "2022-5"
    filter_tidy <- Filter_tidy$new(tidy_table)
    filter_tidy$select_session(session)
    obtained_session <- filter_tidy$aux$Session
    expect_equal(obtained_session, rep(session, 8))
    filter_tidy$select_method(method)
    obtained_session <- filter_tidy$aux$Session
    expect_equal(obtained_session, rep(session, 1))
    obtained_method <- filter_tidy$aux$Method
    expect_equal(obtained_method, rep(method, 1))
  })
  it("Filter both, method first", {
    method <- "Hunting"
    session <- "2022-5"
    filter_tidy <- Filter_tidy$new(tidy_table)
    filter_tidy$select_method(method)
    obtained_method <- filter_tidy$aux$Method
    expect_equal(obtained_method, rep(method, 7))
    filter_tidy$select_session(session)
    obtained_session <- filter_tidy$aux$Session
    expect_equal(obtained_session, rep(session, 1))
    obtained_method <- filter_tidy$aux$Method
    expect_equal(obtained_method, rep(method, 1))
  })
})
