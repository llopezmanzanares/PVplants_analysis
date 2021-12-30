# Technical sunrise and set hours
# I work with the whole set, due to the fact that some plants can be stoped 
# because of fails or maintenance

library(tidyverse)

load("data/processed/pv_e.RData")


tech_ss <- pv_e %>% 
  group_by(date, time) %>% 
  summarise(
    e_kw = sum(kW),    # Energy production per hour
    .groups = "drop_last"
  ) %>% 
  filter(e_kw > 0) %>% # Only hours with energy > 0
  ungroup() %>% 
  group_by(date) %>% 
  summarise(
    sunrise = min(lubridate::hour(time)),
    sunset = max(lubridate::hour(time)),
    .groups = "drop_last"
  )

save(tech_ss, file = "data/processed/tech_ss.RData")
