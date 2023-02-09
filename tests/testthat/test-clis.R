testthat::describe("Cli works", {
  it("cli_get_ramsey_format() works", {
    obtained <- cli_get_ramsey_format()[["species"]]
    expected <- "Coati"
    expect_equal(obtained, expected)
  })
  it("cli_get_multisession_predictions works", {
    obtained <- cli_get_multisession_predictions()[["species"]]
    expected <- "Coati"
    expect_equal(obtained, expected)
  })
})
