library(tidyverse)


f <- function(data){
    result <- tibble(
    Grid_ID = c(1, 2, 1, 2),
        Session = c(1, 1, 2, 2),
        r1 = c(),
        r2 = c(),
        r3 = c(),
        r4 = c(),
        e1 = c(),
        e2 = c(),
        e3 = c(),
        e4 = c()
    )
    return(result)
}
