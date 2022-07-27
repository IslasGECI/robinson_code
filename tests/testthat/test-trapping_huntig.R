library(tidyverse)

describe("Get tidy structure from trapping and hunting data", {
  it("Get hunting effort", {
    path <- "../data/input_trapping_hunting.csv"
    raw_data <- read_csv(path)
    x <- get_hunting_effort(raw_data)
    obtained_hunting_effort <- x$hunting_effort
    expected_hunting_effort <- c(30, 12, 30, 10, 18, 21)
    expect_equal(obtained_hunting_effort, expected_hunting_effort)
  })
})