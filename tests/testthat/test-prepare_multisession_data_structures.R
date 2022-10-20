describe("Prepare multisession data to fit in models", {
  input <- readr::read_csv("data/Hunting.csv")
  obtained_object <- Multisession$new(input)
  it("Object exists", {
    expect_true(exists("obtained_object"))
  })
  it("Obtain unique grids and sessions",{
    expected_unique_grids <- c(9,24,28,31,48,50)
    obtained_unique_grids <- obtained_object$unique_grids()
    is_all_grids <- all(obtained_unique_grids %in% expected_unique_grids)
    expect_true(is_all_grids)
    expected_unique_sessions <- c("2021-8","2021-10","2022-1","2022-3","2022-4","2022-5")
    obtained_unique_sessions <- obtained_object$unique_sessions()
    is_all_sessions <- all(obtained_unique_sessions %in% expected_unique_sessions)
    expect_true(is_all_sessions)
  })
})
