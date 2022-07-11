library(tidyverse)

raw_2_tidy <- function(data) {
  dates <- as.character(data$DateTime)
  result <- tibble(
    date = c(dates),
    camera_ID = c(),
    ocassion = c(),
    coati_count = c()
  )
  return(result)
}
