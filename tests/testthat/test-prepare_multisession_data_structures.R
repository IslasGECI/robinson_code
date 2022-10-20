describe("Prepare multisession data to fit in models", {
  input <- readr::read_csv("../data/Hunting.csv")
  obtained_object <- Multisession$new(input)
  it("Object exists", {
    expect_true(exists("obtained_object"))
  })
  it("Sort session and grid columns", {
    obtained_sorted_multisession <- obtained_object$sort_by_session_and_grid()
    expected_first_6_rows_session <- rep("2021-8", 6)
    obtained_first_6_rows_session <- obtained_sorted_multisession$Session[1:6]
    expect_equal(obtained_first_6_rows_session, expected_first_6_rows_session)
  })
  it("Tests data for multisession model", {
    obtained <- obtained_object$setup_data_for_multisession()
    obtained_first_6_rows_session <- obtained$Session[1:6]
    expected_first_6_rows_session <- rep(1, 6)
    expect_equal(obtained_first_6_rows_session, expected_first_6_rows_session)
    expected_rows_number <- 36
    obtained_rows_number <- nrow(obtained)
    expect_equal(obtained_rows_number, expected_rows_number)
    expected_columns_number <- 14
    obtained_columns_number <- ncol(obtained)
    expect_equal(obtained_columns_number, expected_columns_number)
    expected <- read_csv("../data/data_for_multisession.csv", show_col_types = FALSE)
    expect_equal(obtained, expected)
  })
})
