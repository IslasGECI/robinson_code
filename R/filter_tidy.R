
Filter_tidy <- R6::R6Class("Filter_tidy",
  public = list(
    tidy_table = NULL,
    aux = NULL,
    initialize = function(tidy_table) {
        self$tidy_table <- tidy_table %>% arrange(ocassion)
        self$aux <- tidy_table %>% arrange(ocassion)
    },
    select_session = function(month) {
        self$aux <- self$aux %>% filter(session == month)
    },
    select_method = function(method) {
        self$aux <- self$aux %>% filter(Method == method)
    },
    spatial = function() {
      final_structure <- tidy_2_final(self$aux)
      final_structure <- final_structure %>% arrange(Grid)
      return(final_structure)
    }
  )
)
