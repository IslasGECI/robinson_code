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
