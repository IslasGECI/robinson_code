library(tidyverse)

describe("Get removals and effort from hunting", {
    hunting_path <- "../data/hunting_database_for_tests.csv"
    hunting_data <- read_csv(hunting_path,  show_col_types = FALSE)
    it("test get_hunting_effort", {
        obtained_effort <- get_hunting_effort(hunting_data)
        expected_effort <- c(2, 2, 2, 5, 36, 12, 21)
        expect_equal(obtained_effort$hunting_effort, expected_effort)
    })
    it("test get_ocassion with new tables", {
        obtained_ocassion <- get_ocassion(hunting_data)
        expected_ocassion <- c(31, 35, 42, 1, 11, 14, 20) 
        expect_equal(obtained_ocassion$Ocassion, expected_ocassion)
    })
    it("test get_session_and_year with new tables", {
        obtained_session <- get_session_and_year(hunting_data)
        expected_session <- c("2021-8", "2021-8", "2021-10", "2022-1", "2022-3", "2022-4", "2022-5") 
        expect_equal(obtained_session$Session, expected_session)
    })
})
