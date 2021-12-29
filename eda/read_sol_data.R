# read file of sunrise and sunset hours

library(tidyverse)

ss <- scan(
  file = "data/raw/sol_2007.txt",
  what = character(),
  sep = "\n",
  quiet = T
)[7:37] %>% 
  str_trim(., side = "left") %>%     # replace blanks with ;
  str_replace_all(., "  ", ";") %>% 
  str_replace_all(., " ", ";") %>% 
  str_replace_all(., ";;;;;;", "; ; ;") %>% 
  str_split(., ";", simplify = T)    # generate a matrix structure

ss_ds <- as_tibble(ss)
# names to the dataset
names(ss_ds) <-
  c(
    "n_dia",
    str_c(
      rep(month.abb, each=2),
      c("_ort", "_ocs")
      )
    )
