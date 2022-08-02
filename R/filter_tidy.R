
Filter_tidy <- R6::R6Class("Filter_tidy",
  public = list(
    tidy_table = NULL,
    aux = NULL,
    initialize = function(tidy_table) {
        self$tidy_table <- tidy_table
        self$aux <- tidy_table
    },
    select_session = function(month) {
        self$aux <- self$aux %>% filter(session == month)
    },
    select_method = function(method) {
        self$aux <- self$aux %>% filter(Method == method)
    },
    spatial = function() {
      path_expected <- "../data/hunting_final_structure.csv"
      expected_final_structure <- read_csv(path_expected)
    }
  )
)
