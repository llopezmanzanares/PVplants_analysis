# Read excel with production data and transform it in a R object

library(tidyverse)
library(readxl)

pv_e <- read_xls("data/raw/200802_8_Plantas.xls", sheet = 1) %>% 
  rename(
    date = Fecha,
    time = Hora
  ) %>% 
  mutate(
    date = as.Date(date, "%d/%m/%Y"),
    time = lubridate::hm(time)
    ) %>% 
  filter(!is.na(date)) %>% 
  pivot_longer(
    -c(date, time),
    names_to = "plant_id",
    values_to = "kW"
  )

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
