library(tidyverse)

describe("We define the expected data structures", {
  it("Expected data structure", {
    path_cameras <- "../data/raw_cameras.csv"
    path_field <- "../data/input_trapping_hunting.csv"
    path_coordinates <- "../data/camera_traps_coordinates.csv"
    paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
    tidy_table <- tidy_from_path(paths)
    obtained_final_structure <- tidy_2_final(tidy_table)
    expected_final_structure <- tibble(
      Grid = c(38, 15, 31),
      session = c(4, 4, 4),
      Method = c("Camera-Traps", "Camera-Traps", "Camera-Traps"),
      r_1 = c(1, NA, NA),
      r_2 = c(NA, 1, 0),
      e_1 = c(1, NA, NA),
      e_2 = c(NA, 1, 1)
    )
    expect_equal(obtained_final_structure, expected_final_structure)
  })
})
