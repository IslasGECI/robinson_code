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
