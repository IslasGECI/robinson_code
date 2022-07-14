library(tidyverse)


#' @export
tidy_2_final <- function(tidy_table) {
  first_month_week <- min(tidy_table$ocassion)
  tidy_table <- tidy_table %>% mutate(ocassion = ocassion - first_month_week + 1)
  final <- tidy_table %>%
    pivot_wider(names_from = ocassion, values_from = c(r, e))
  return(final)
}
