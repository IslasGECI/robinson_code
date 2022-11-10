library(tidyverse)

testthat::describe("Get removals and effort from observations", {
  observations_path <- "../data/observations_database_for_tests.csv"
  hunting_path <- "../data/hunting_database_for_tests.csv"
  trapping_path <- "../data/trapping_database_for_tests.csv"
  it("test concatenate observations from hunting and trapping", {
    path_list <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = observations_path)
    obtained_observations_tidy <- concatenate_observations_from_trapping_and_hunting(path_list)
    expected_observations_tidy <- read_csv("../data/output_concatenate_observations_from_trapping_and_hunting.csv", show_col_types = FALSE)
    expect_equal(obtained_observations_tidy, expected_observations_tidy)
  })
  it("test tidy observations", {
    path_list <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = observations_path)
    obtained_observations_tidy <- tidy_from_path_observation(path_list)
    expected_observations_tidy <- read_csv("../data/test_tidy_for_observations.csv", show_col_types = FALSE)
    expect_equal(obtained_observations_tidy, expected_observations_tidy)
  })
})
