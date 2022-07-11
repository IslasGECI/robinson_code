library(tidyverse)

raw_2_ocassion <- function(data) {
  dates <- as.character(data$DateTime)
  ocassions <- lubridate::week(dates)
  result <- tibble(
    date = dates,
    ocassion = ocassions,
    camera_ID = c(),
    coati_count = c()
  )
  return(result)
}
