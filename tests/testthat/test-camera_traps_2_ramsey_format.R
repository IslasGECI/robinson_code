library(tidyverse)

testthat::describe("Prepare camera traps data to Ramsey format", {
  it("Gold test 🏅", {
    camera_sightings <- read_csv("../data/input_ramsey_format.csv")
    obtained <- camera_traps_2_ramsey_format(camera_sightings)
    obtained_path <- "../data/ramsey_format.csv"
    obtained_hash <- tools::md5sum(obtained_path)
    expected_hash <- "426e2eba1b5ca13c8e3e3197bb9841f5"
    expect_equal(obtained_hash[[1]], expected_hash)
  })
})
