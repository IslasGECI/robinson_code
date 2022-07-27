library(tidyverse)

describe("Get tidy structure from trapping and hunting data", {
  path <- "../data/input_trapping_hunting.csv"
  raw_data <- read_csv(path)
  x <- get_hunting_effort(raw_data) %>% get_ocassion() %>% get_session()
  it("Get hunting effort", {
    obtained_hunting_effort <- x$hunting_effort
    expected_hunting_effort <- c(30, 12, 30, 10, 18, 21)
    expect_equal(obtained_hunting_effort, expected_hunting_effort)
  })
  it("Get ocassion", {
    obtained_ocassion <- x$ocassion
    expected_ocassion <- c(12, 14, 14, 15, 16, 20)
    expect_equal(obtained_ocassion, expected_ocassion)
  })
  it("Get session", {
    obtained_session <- x$session
    expected_session <- c(3, 4, 4, 4, 4, 5)
    expect_equal(obtained_session, expected_session)
  })
})
