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
  it("cli_for_plot works: default", {
    obtained <- cli_for_plot()[["month"]]
    expected <- "2022-7"
    expect_equal(obtained, expected)
  })
  it("Use in script", {
    src_file <- "/workdir/tests/src/cli_for_plot.R"
    expected_month <- "2022-9"
    command <- glue::glue("Rscript {src_file} --month {expected_month}")
    output <- system(command, intern = TRUE)
    expected <- stringr::str_detect(output, expected_month)
    expect_true(expected)
  })
})
