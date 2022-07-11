library(tidyverse)

raw_2_ocassion <- function(data) {
  dates <- as.character(data$DateTime)
  result <- tibble(
    date = c(dates),
    ocassion = c(),
    camera_ID = c(),
    coati_count = c()
  )
  return(result)
}
