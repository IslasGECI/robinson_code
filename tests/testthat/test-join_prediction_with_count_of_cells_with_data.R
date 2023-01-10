testthat::describe("The paths are right", {
  it("Cats", {
    Writer <- Writer_Prediction_And_Cells_With_Camera_Data$new("Cats")
    expect_equal(Writer$predictions_path, "data/preds_1km_grid-cats.csv")
    expect_equal(Writer$multisession_data_path, "data/multisession-Camera-Traps-Cats.csv")
    expect_equal(Writer$output_path, "/workdir/prediction_with_count_cells.csv")
  })
  it("Coati", {
    Writer <- Writer_Prediction_And_Cells_With_Camera_Data$new("Coatis")
    expect_equal(Writer$predictions_path, "data/preds_1km_grid.csv")
    expect_equal(Writer$multisession_data_path, "data/multisession-Camera-Traps.csv")
    expect_equal(Writer$output_path, "/workdir/prediction_with_count_cells_coatis.csv")
  })
  it("Without species", {
    expect_error(Writer_Prediction_And_Cells_With_Camera_Data$new())
  })
})
