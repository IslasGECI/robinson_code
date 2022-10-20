describe("Prepare multisession data to fit in models", {
  it("Object exists", {
    input <- read_csv("data/Hunting.csv")
    obtained_object <- Multisession$new(input)
    expect_true(exists("obtained_object"))
  })
})
