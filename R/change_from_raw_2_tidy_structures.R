library(tidyverse)

raw_2_tidy <- function(data) {
  result <- tibble(
    date = c(),
    Grid_ID = c(),
    r = c(),
    e = c()
  )
  return(result)
}
