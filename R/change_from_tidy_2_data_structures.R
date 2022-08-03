library(tidyverse)
library(lubridate)

get_first_last_week_from_month <- function(month) {
  first_day_of_month_string <- paste0("2022-", month, "-01")
  first_day_of_month <- ymd(first_day_of_month_string)
  first_week_of_month <- week(first_day_of_month)
  last_of_january <- ymd("2022-01-31")
  last_day_of_month <- last_of_january %m+% months(month - 1)
  last_week_of_month <- week(last_day_of_month)
  return(c(first_week_of_month, last_week_of_month))
}

#' @export
tidy_2_final <- function(tidy_table) {
  first_month_week <- min(tidy_table$ocassion)
  tidy_table <- tidy_table %>% mutate(ocassion = ocassion - first_month_week + 1)
  final <- tidy_table %>%
    pivot_wider(names_from = ocassion, values_from = c(r, e))
  return(final)
}
