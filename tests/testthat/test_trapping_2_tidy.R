library(tidyverse)

describe("Get removals and effort from trapping", {
  trapping_path <- "../data/trapping_database_for_tests.csv"
  trapping_data <- read_csv(trapping_path, show_col_types = FALSE)
  it("test tidy trapping", {
    obtained_trapping_tidy <- tidy_from_path_by_method(trapping_path, get_removal_and_effort_trapping)
    expected_trapping_tidy <- read_csv("../data/test_tidy_for_trapping.csv")
    expect_equal(obtained_trapping_tidy, expected_trapping_tidy)
  })
  }
)