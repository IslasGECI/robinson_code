library(tidyverse)

describe("We define the expected data structures", {
  it("Expected data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected <- tibble(
      Grid_ID = c(1),
      Session = c(1),
      r1 = c(0),
      r2 = c(),
      r3 = c(),
      r4 = c(),
      e1 = c(3),
      e2 = c(),
      e3 = c(),
      e4 = c()
    )
    obtained <- f(data)
    expect_equal(expected, obtained)
  })
  it("Read camaras with a detection", {
    path <- "../data/raw_cameras_with_detection.csv"
    data <- read_csv(path)
    expected <- tibble(
      Grid_ID = c(1),
      Session = c(1),
      r1 = c(1),
      r2 = c(),
      r3 = c(),
      r4 = c(),
      e1 = c(3),
      e2 = c(),
      e3 = c(),
      e4 = c()
    )
    obtained <- f(data)
    expect_equal(expected, obtained)
  })
})
