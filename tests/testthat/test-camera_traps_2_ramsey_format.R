library(tidyverse)

testthat::describe("Prepare camera traps data to Ramsey format", {
  it("Gold test 🏅", {
    camera_sightings <- read_csv("../data/input_ramsey_format.csv", show_col_types = FALSE)
    obtained <- camera_traps_2_ramsey_format(camera_sightings)
    obtained_path <- "../data/ramsey_format.csv"
    write_csv(obtained, obtained_path)
    obtained_hash <- tools::md5sum(obtained_path)
    expected_hash <- "c0ac40ca5e15f5e0065d586cad8d8aa0"
    expect_equal(obtained_hash[[1]], expected_hash)
  })
})
