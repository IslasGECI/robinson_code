describe("Get version of the module", {
  it("The version is 0.1.0", {
    expected_version <- c("0.1.0")
    obtained_version <- packageVersion("robinson")
    version_are_equal <- expected_version == obtained_version
    expect_true(version_are_equal)
  })
})
