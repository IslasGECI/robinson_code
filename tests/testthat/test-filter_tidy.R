library(tidyverse)

describe("Test tidy filters", {
  path_cameras <- "../data/raw_cameras.csv"
  path_field <- "../data/input_trapping_hunting.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(paths)
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
    expect_equal(obtained_session, rep(session, 3))
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
