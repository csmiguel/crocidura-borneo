#auxiliary functions
# replace any na in vector.
replacena <- function(x) {
  x[which(x == "na")] <- NA
  x
}

#convert ft to meters in variable
ft_2_mt <- function(x){
  vector_ft <- grep(pattern = "ft", x)
  ft_m <-
    x[vector_ft] %>%
    stringr::str_extract("[0-9]++") %>%
    as.numeric() %>% {.* 0.3048}
  x[vector_ft] <- ft_m
  x
}
