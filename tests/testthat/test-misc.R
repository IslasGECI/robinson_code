describe("return path of output file", {
  it("writes april", {
    expected_path <- "data/april_camera_traps.csv"
    obtained_path <- path_for_cameras(month_number = 4)
    expect_equal(obtained_path, expected_path)
  })
  it("writes march", {
    expected_path <- "data/march_camera_traps.csv"
    obtained_path <- path_for_cameras(month_number = 3)
    expect_equal(obtained_path, expected_path)
  })
  it("writes december", {
    expected_path <- "data/december_camera_traps.csv"
    obtained_path <- path_for_cameras(month_number = 12)
    expect_equal(obtained_path, expected_path)
  })
})
