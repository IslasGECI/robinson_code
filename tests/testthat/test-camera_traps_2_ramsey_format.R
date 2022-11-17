library(tidyverse)

testthat::describe("Prepare camera traps data to Ramsey format", {
  it("Gold test 🏅", {
    camera_sightings <- read_csv("../data/input_ramsey_format.csv")
    obtained <- camera_traps_2_ramsey_format(camera_sightings)
    obtained_path <- "../data/ramsey_format.csv"
    write_csv(obtained, obtained_path)
    obtained_hash <- tools::md5sum(obtained_path)
    expected_hash <- "cecb6bde91f0e8f99139fec580ccbb14"
    expect_equal(obtained_hash[[1]], expected_hash)
  })
})
