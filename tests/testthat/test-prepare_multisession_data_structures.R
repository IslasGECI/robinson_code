describe("Prepare multisession data to fit in models", {
  input <- readr::read_csv("data/Hunting.csv")
  obtained_object <- Multisession$new(input)
  it("Object exists", {
    expect_true(exists("obtained_object"))
  })
  it("Obtain present grids and sessions", {
    expected_present_grids <- c(9, 24, 28, 31, 48, 50)
    obtained_present_grids <- obtained_object$present_grids()
    is_all_grids <- all(obtained_present_grids %in% expected_present_grids)
    expect_true(is_all_grids)
    expected_present_sessions <- c("2021-8", "2021-10", "2022-1", "2022-3", "2022-4", "2022-5")
    obtained_present_sessions <- obtained_object$present_sessions()
    is_all_sessions <- all(obtained_present_sessions %in% expected_present_sessions)
    expect_true(is_all_sessions)
  })
  it("Obtain expanded grids and sessions", {
    expected_rows_number <- 36
    obtained_rows_number <- nrow(obtained_object$expanded_grid_session())
    expect_equal(obtained_rows_number, expected_rows_number)
  })
})
