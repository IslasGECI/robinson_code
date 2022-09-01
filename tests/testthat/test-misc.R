test_that("multiplication works", {
  expected_path <- "data/april_camera_traps.csv"
  obtained_path <- path_for_cameras(month_number = 4)
  expect_equal(obtained_path, expected_path)
})
