library(tidyverse)

describe("We define the expected data structures", {
  path_cameras <- "../data/raw_cameras.csv"
  path_field <- "../data/input_trapping_hunting.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
  tidy_table <- get_tidy_from_field_and_cameras(paths)
  it("Expected Camera-Traps data structure", {
    method <- "Camera-Traps"
    obtained_final_structure <- tidy_2_final(tidy_table %>% filter(Method == method))
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
  it("Expected Hunting data structure", {
    method <- "Hunting"
    obtained_final_structure <- tidy_2_final(tidy_table %>%
      arrange(ocassion) %>%
      filter(Method == method, session == 4)) %>%
      arrange(Grid)

    path_expected <- "../data/hunting_final_structure.csv"
    expected_final_structure <- read_csv(path_expected)
    expect_equal(obtained_final_structure, expected_final_structure)
  })
})
