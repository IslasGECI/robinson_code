library(tidyverse)


get_first_last_week_from_month <- function(month){
  return(c(13,18))
}

#' @export
tidy_2_final <- function(tidy_table) {
  first_month_week <- min(tidy_table$ocassion)
  tidy_table <- tidy_table %>% mutate(ocassion = ocassion - first_month_week + 1)
  final <- tidy_table %>%
    pivot_wider(names_from = ocassion, values_from = c(r, e))
  return(final)
}
