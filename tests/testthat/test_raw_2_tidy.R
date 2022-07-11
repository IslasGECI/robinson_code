library(tidyverse)

describe("Define tidy data structure", {
    it("Expected tidy data structure", {
        path <- "../data/raw_cameras.csv"
        data <- read_csv(path)
        raw_2_tidy(data)
    })
})
