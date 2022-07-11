library(tidyverse)

raw_2_ocassion <- function(data) {
  dates <- as.character(data$DateTime)
  get_ocassion <- lubridate::week(dates)
  result <- tibble(
    date = c(dates),
    ocassion = get_ocassion,
    camera_ID = c(),
    coati_count = c()
  )
  return(result)
}
