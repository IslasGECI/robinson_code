testthat::describe("Add months column", {
  it(" Add column from original table", {
    original_table <- read_csv("../data/prediction_with_months.csv", show_col_types = FALSE)
    expected_table <- read_csv("../data/preds_1km_grid-cats_with_number_of_cells.csv", show_col_types = FALSE)
    obtained_table <- add_month_names(original_table)
    expect_equal(expected_table, obtained_table)
  })
})

testthat::describe("Change session to months", {
  it("Test two sessions", {
    number_of_sessions <- 2
    obtained_months <- fill_months(number_of_sessions, initial_month = "2021-10")
    expected_months <- c("October 2021", "November 2021")
    expect_equal(obtained_months, expected_months)
  })
  it("Test three sessions", {
    number_of_sessions <- 3
    obtained_months <- fill_months(number_of_sessions, initial_month = "2021-10")
    expected_months <- c("October 2021", "November 2021", "December 2021")
    expect_equal(obtained_months, expected_months)
  })
})
testthat::describe("Add months column", {
  it("Change month number to spanish month name", {
    month_number <- 1
    obtained_name <- replace_number_with_spanish_name(month_number)
    expect_true(is.character(obtained_name))
    expected_name <- "enero"
    expect_equal(obtained_name, expected_name)
    month_number <- 5
    obtained_name <- replace_number_with_spanish_name(month_number)
    expected_name <- "mayo"
    expect_equal(obtained_name, expected_name)
  })
  it("Paste month name and year", {
    month_in_spanish <- "enero"
    year <- "2021"
    obtained_name_and_year <- add_month_in_spanish_and_year(month_in_spanish, year)
    expect_true(is.character(obtained_name_and_year))
    expected_name_and_year <- "enero de 2021"
    expect_equal(obtained_name_and_year, expected_name_and_year)
  })
})
