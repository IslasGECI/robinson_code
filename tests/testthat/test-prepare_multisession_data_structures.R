describe("Prepare multisession data to fit in models",{
  it("Object exists",{
    obtained_object <- Multisession$new()
    expect_true(exists("obtained_object"))
  })
})