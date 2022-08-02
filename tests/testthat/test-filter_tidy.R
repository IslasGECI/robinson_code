library(tidyverse)

describe("Test tidy filters", {
  path_cameras <- "../data/raw_cameras.csv"
  path_field <- "../data/input_trapping_hunting.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(paths)
  it("Session returns same number", {
    final_structure <- Filter_tidy$new(tidy_table)
    obtained_table <- final_structure$select_session(4)
    obtained_session <- obtained_table$session
    expected_session <- rep(4,3)
    expect_equal(obtained_session, expected_session)
  })
})
