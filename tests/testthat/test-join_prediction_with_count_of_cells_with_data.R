test_that("The paths are right", {
  Writer <- Writer_Prediction_And_Cells_With_Camera_Data$new()
  expect_equal(Writer$path_predictions, "path predictions")
})
