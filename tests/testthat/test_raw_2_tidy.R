library(tidyverse)

describe("Define tidy data structure", {
  it("Expected tidy data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected_tidy <- tibble(
      date = c(),
      Grid_ID = c(),
      r = c(),
      e = c()
    )
    obtained_tidy <- raw_2_tidy(data)
    expect_equal(expected_tidy, obtained_tidy)
  })
})
