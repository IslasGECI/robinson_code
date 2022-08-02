library(tidyverse)

describe("Test tidy filters", {
  path_cameras <- "../data/raw_cameras.csv"
  path_field <- "../data/input_trapping_hunting.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(paths)
  final_structure <- Filter_tidy$new(tidy_table)
  it("Session returns same number", {
    obtained_table <- final_structure$select_session(3)
    obtained_session <- obtained_table$session
    expected_session <- rep(3,3)
    expect_equal(obtained_session, expected_session)
    obtained_table <- final_structure$select_session(4)
    obtained_session <- obtained_table$session
    expected_session <- rep(4,18)
    expect_equal(obtained_session, expected_session)
  })
  it("Filter by method", {
    method <- "Camera-Traps"
    obtained_table <- final_structure$select_method(method)
    obtained_method <- obtained_table$Method
    expected_method <- rep("Camera-Traps", 3)
    expect_equal(obtained_method, expected_method)
  })
  it("Filter both",{
    method <- "Hunting" 
    session <- 4
    filter_tidy <- Filter_tidy$new(tidy_table)
    filter_tidy$select_session(session)
    filtered <- filter_tidy$select_method(method)
    expect_equal(filtered$Method, rep("Hunting", 5))
  })
})
