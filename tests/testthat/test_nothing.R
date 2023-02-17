testthat::describe("Get version of the module", {
  it("The version is 1.0.0", {
    expected_version <- c("1.0.0")
    obtained_version <- packageVersion("robinson")
    version_are_equal <- expected_version == obtained_version
    expect_true(version_are_equal)
  })
})
