library(tidyverse)

describe("We define the expected data structures", {
  it("Expected data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected <- tibble(
      Grid_ID = c(1, 2, 1, 2),
      Session = c(1, 1, 2, 2),
      r1 = c(),
      r2 = c(),
      r3 = c(),
      r4 = c(),
      e1 = c(),
      e2 = c(),
      e3 = c(),
      e4 = c()
    )
    obtained <- f(data)
    expect_equal(expected, obtained)
  })
  it("Read raw_cameras data", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
  })
})
