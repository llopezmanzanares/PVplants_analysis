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

# daily data graphs
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

# monthly data graphs
ggplot(totals_month, aes(as.factor(month), kwh)) +
  geom_col(fill = "gold3") +
  facet_wrap(~plant_id, ncol = 1) +
  labs(
    title = "Energy production per month",
    subtitle = "kWh",
    x = "Month",
    y = "kWh"
  ) +
  theme_minimal()


# Integration factor analysis ------------------------------------------------------

load("data/processed/tech_ss.RData")

# production time, sun hours
prod_time <- pv_e %>% 
  pivot_wider(
    names_from = "plant_id",
    values_from = "kW",
    values_fn = mean
  ) %>% 
  left_join(tech_ss, by = "date") %>% 
  mutate(
    time = as.numeric(time)/3600,
    dl = if_else(time >= sunrise & time <= sunset, T, F)
  ) %>% 
  filter(dl) %>% 
  select(date:`6E`) %>% 
  pivot_longer(
    -c("date", "time"),
    names_to = "plant_id",
    values_to = "kw"
  )

ggplot(prod_time, aes(kw)) +
  geom_histogram(binwidth = 1) +
  facet_wrap(~plant_id, ncol = 1) +
  theme_minimal()
