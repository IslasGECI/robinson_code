library(tidyverse)

describe("Define tidy data structure", {
  it("Expected tidy data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected_date <- "2022-04-02 07:25:23"
    expected_tidy <- tibble(
      date = c(expected_date),
      Grid_ID = c(),
      r = c(),
      e = c()
    )
    obtained_tidy <- raw_2_tidy(data)
    expect_equal(expected_tidy, obtained_tidy)
  })
  it("Expected date format", {
#    path <- "../data/raw_cameras.csv"
#    data <- read_csv(path)
#    obtained_tidy <- raw_2_tidy(data)
#    obtained_date <- obtained_tidy$date[1]
#    expected_date <- "2022-04-02 07:25:23"
#    expect_equal(expected_date,obtained_date)
  })
})
