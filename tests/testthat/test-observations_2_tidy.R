library(tidyverse)

describe("Get removals and effort from observations", {
  observations_path <- "../data/observations_database_for_tests.csv"
  hunting_path <- "../data/hunting_database_for_tests.csv"
  trapping_path <- "../data/trapping_database_for_tests.csv"
  it("test concatenate observations from hunting and trapping", {
    path_list <- list("hunting" = hunting_path, "trapping" = trapping_path)
    obtained_observations_tidy <- concatenate_observations_from_trapping_and_hunting(path_list)
    expected_observations_tidy <- read_csv("../data/output_concatenate_observations_from_trapping_and_hunting.csv")
    expect_equal(obtained_observations_tidy, expected_observations_tidy)
  })
  it("test tidy observations", {
    path_list <- list("hunting" = hunting_path, "trapping" = trapping_path, "observations" = observations_path)
    obtained_trapping_tidy <- tidy_from_path_by_method(trapping_path, get_removal_and_effort_trapping)
    expected_trapping_tidy <- read_csv("../data/test_tidy_for_trapping.csv")
    expect_equal(obtained_trapping_tidy, expected_trapping_tidy)
  })
})
