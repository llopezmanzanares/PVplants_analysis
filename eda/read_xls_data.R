# Read excel with production data and transform it in a R object

library(tidyverse)
library(readxl)

pv_e <- read_xls("data/raw/200802_8_Plantas.xls") %>% 
  rename(
    date = Fecha,
    time = Hora
  ) %>% 
  mutate(
    date = strptime(
      str_c(date, time, sep=" "),
      format = "%d/%m/%Y %H:%M"
    )
  ) %>% 
  filter(!is.na(date)) %>% 
  select(-time)

save(pv_e, "data/processed/pv_e")