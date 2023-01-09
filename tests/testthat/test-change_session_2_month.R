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
