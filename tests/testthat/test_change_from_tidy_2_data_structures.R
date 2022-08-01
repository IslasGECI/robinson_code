library(tidyverse)

describe("We define the expected data structures", {
  it("Expected data structure", {
    path <- "../data/raw_cameras.csv"
    tidy_table <- tidy_from_path(path)
    obtained_final_structure <- tidy_2_final(tidy_table)
    expected_final_structure <- tibble(
      camera_id = c(1, 2, 10),
      Method = c("Camera-Traps", "Camera-Traps", "Camera-Traps"),
      session = c(4, 4, 4),
      r_1 = c(1, NA, NA),
      r_2 = c(NA, 0, 1),
      e_1 = c(1, NA, NA),
      e_2 = c(NA, 1, 1)
    )
    expect_equal(obtained_final_structure, expected_final_structure)
  })
})
