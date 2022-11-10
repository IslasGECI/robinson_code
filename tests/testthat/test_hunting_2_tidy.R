library(tidyverse)

testthat::describe("Get removals and effort from hunting", {
  hunting_path <- "../data/hunting_database_for_tests.csv"
  hunting_data <- read_csv(hunting_path, show_col_types = FALSE)
  it("test get_person_day_effort", {
    obtained_effort <- get_person_day_effort(hunting_data)
    expected_effort <- c(2, 2, 2, 5, 36, 12, 21)
    expect_equal(obtained_effort$Person_day_effort, expected_effort)
  })
  it("test get_ocassion with new tables", {
    obtained_ocassion <- get_ocassion(hunting_data)
    expected_ocassion <- c(32, 36, 43, 2, 12, 15, 21)
    expect_equal(obtained_ocassion$Ocassion, expected_ocassion)
  })
  it("test get_session with new tables", {
    obtained_session <- get_session(hunting_data)
    expected_session <- c("2021-8", "2021-8", "2021-10", "2022-1", "2022-3", "2022-4", "2022-5")
    expect_equal(obtained_session$Session, expected_session)
  })
  it("test select_columns with new tables", {
    selected_columns <- select_columns(hunting_data)
    obtained_number_of_columns <- ncol(selected_columns)
    expected_number_of_columns <- ncol(hunting_data) - 2
    expect_equal(obtained_number_of_columns, expected_number_of_columns)
  })
  it("test tidy hunting", {
    obtained_hunting_tidy <- tidy_from_path_by_method(hunting_path, get_removal_and_effort_hunting)
    expected_hunting_tidy <- read_csv("../data/test_tidy_for_hunting.csv", show_col_types = FALSE)
    expect_equal(obtained_hunting_tidy, expected_hunting_tidy)
  })
})
