# read file of sunrise and sunset hours
# output: date, time and sunrise/sunset (ort/ocs)

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

ss_ds <- as_tibble(ss, .name_repair = "unique")
# names to the dataset
names(ss_ds) <-
  c(
    "n_dia",
    str_c(
      rep(month.abb, each=2),
      c("_ort", "_ocs")
      )
    )

s_rs <- ss_ds %>% 
  pivot_longer(
    -n_dia,
    names_to = "tipo",
    values_to = "hora"
  ) %>% 
  filter(hora != " ")

s_rs <- s_rs %>%  
  mutate(
    month = str_sub(tipo, 1, 3),
    month = match(month, month.abb),
    rs = str_sub(tipo, 5, 7),
    hora = as.numeric(hora),
    hour = hora %/% 100,
    minute = hora %% 100,
    time = lubridate::hm(str_c(
      hour, minute,
      sep = ":")
      ),
    fecha = str_c(
      "2007", month, n_dia,
      sep = "/"
    ),
    fecha = as.Date(fecha, "%Y/%m/%e")
  ) %>% 
  select(fecha, time, rs)

save(s_rs, file = "data/processed/sunriseset.RData")
