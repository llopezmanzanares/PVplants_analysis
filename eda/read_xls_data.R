# Read excel with production data and transform it in a R object

library(tidyverse)
library(readxl)

pv_e <- read_xls("data/raw/200802_8_Plantas.xls", sheet = 1) %>% 
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

save(pv_e, file = "data/processed/pv_e.RData")

# plants characteristics
pv_c <- read_xls("data/raw/200802_8_Plantas.xls", sheet = 2) %>% 
  rename(
    id = planta,
    cod = `CÓDIGO`,
    geom = `geometría`,
    n_mods = `# módulos`,
    pn = `P nominal (kW)`,
    pf = `P flashing (kW)`,
    mt = `LÍNEA MT`
  )

save(pv_c, file = "data/processed/pv_c.RData")
