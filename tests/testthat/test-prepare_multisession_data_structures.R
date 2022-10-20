describe("Prepare multisession data to fit in models", {
  input <- readr::read_csv("../data/Hunting.csv")
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
  it("Obtain complete multisession structure", {
    obtained_complete_multisession <- obtained_object$get_complete_multisession()
    expected_rows_number <- 36
    obtained_rows_number <- nrow(obtained_complete_multisession)
    expect_equal(obtained_rows_number, expected_rows_number)
    expected_columns_number <- 14
    obtained_columns_number <- ncol(obtained_complete_multisession)
    expect_equal(obtained_columns_number, expected_columns_number)
    is_any_na <- any(is.na(obtained_complete_multisession))
    expect_false(is_any_na)
  })
  it("Sort session and grid columns", {
    obtained_sorted_multisession <- obtained_object$sort_by_session_and_grid()
    expected_first_6_rows_session <- rep("2021-8", 6)
    obtained_first_6_rows_session <- obtained_sorted_multisession$Session[1:6]
    expect_equal(obtained_first_6_rows_session, expected_first_6_rows_session)
  })
  it("Add new session column", {
    obtained_added_session_column <- obtained_object$rename_session()
    obtained_first_6_rows_session <- obtained_added_session_column$Session[1:6]
    expected_first_6_rows_session <- rep(1, 6)
    expect_equal(obtained_first_6_rows_session, expected_first_6_rows_session)
  })
  it("Tests data for multisession model", {
    expected <- read_csv("../data/data_for_multisession.csv", show_col_types=FALSE)
    obtained <- obtained_object$setup_data_for_multisession()
    expect_equal(obtained, expected)
  })
})
