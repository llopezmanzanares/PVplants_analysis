# Basic analysis

library(tidyverse)

load("data/processed/pv_e.RData") # energy per hour


# Totals ------------------------------------------------------------------

totals <- pv_e %>% 
  group_by(plant_id) %>% 
  summarise(
    hours = n(),
    kwh = sum(kW),
    .groups = "drop_last"
  ) %>% 
  ungroup() %>% 
  mutate(
    ratio = round(100 * kwh / sum(kwh), 2), # percentage of total
    pct = round(100 + kwh / max(kwh), 2)    # distance to max
  )

totals_month <- pv_e %>% 
  group_by(
    plant_id,
    month = lubridate::month(date)
  ) %>% 
  summarise(
    kwh = sum(kW),
    .groups = "drop_last"
  ) %>% 
  ungroup()

totals_day <- pv_e %>% 
  group_by(
    plant_id,
    date
  ) %>% 
  summarise(
    kwh = sum(kW),
    .groups = "drop_last"
  ) %>% 
  ungroup()

ggplot(totals_day, aes(date, kwh)) +
  geom_line(aes(color = plant_id)) +
  geom_smooth() +
  facet_wrap(
    vars(month = lubridate::month(date)),
    scales = "free_x"
  ) +
  labs(
    title = "Energy productions per day",
    subtitle = "kWh",
    x = "Day",
    y = "kWh",
    color = NULL
  ) +
  theme_minimal()
