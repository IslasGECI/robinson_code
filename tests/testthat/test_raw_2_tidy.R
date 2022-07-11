library(tidyverse)

describe("Define tidy data structure", {
  it("Expected tidy data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected_dates <- c(
      "2022-04-02 07:25:23",
      "2022-04-02 07:25:26",
      "2022-04-02 07:25:29",
      "2022-04-02 07:25:32",
      "2022-04-04 02:02:42",
      "2022-04-04 02:02:45"
    )
    expected_tidy <- tibble(
      date = c(expected_dates),
      Grid_ID = c(),
      r = c(),
      e = c()
    )
    obtained_tidy <- raw_2_tidy(data)
    expect_equal(expected_tidy, obtained_tidy)
  })
})
