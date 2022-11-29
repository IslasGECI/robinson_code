library(tidyverse)

select_effort <- function(multi_data) {
  result <- multi_data %>% select(-starts_with("r"))
  return(result)
}
