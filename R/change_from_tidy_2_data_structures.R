library(tidyverse)


get_cameras_data_structure <- function(data) {
  coati_count <- sum(data$CoatiCount)
  result <- tibble(
    Grid_ID = c(1),
    Session = c("April"),
    r1 = c(coati_count),
    r2 = c(),
    r3 = c(),
    r4 = c(),
    e1 = c(3),
    e2 = c(),
    e3 = c(),
    e4 = c()
  )
  return(result)
}

#' @export
tidy_2_final <- function(tidy_table){
  first_month_week = min(tidy_table$ocassion)
  tidy_table <- tidy_table %>% mutate(ocassion = ocassion - first_month_week + 1 )
  final <- tidy_table %>%
    pivot_wider(names_from = ocassion, values_from = c(r, e))
  return(final)
}
