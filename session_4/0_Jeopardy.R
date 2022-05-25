library(tidyverse)

rewe <- read_csv("./data/rewe_products.csv")

rewe %>% 
  select(fatInGram, energyInKcal) %>% 
  drop_na() %>% 
  ggplot() +
  aes(x = fatInGram, y = energyInKcal ) +
  geom_point(alpha = .05)


rewe %>% 
  colnames()

covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

library(lubridate)

covid %>% 
  filter(location %in% c("Germany", "Portugal", "Italy", "Spain")) %>% 
  filter(year(date) == 2021) %>% 
  select(location, new_deaths_per_million) %>% 
  ggplot() +
  aes(x = new_deaths_per_million) +
  geom_histogram() +
  facet_wrap(~location)

# Antwort:

covid %>% 
  distinct(continent)

covid %>% 
  select(location, continent, aged_65_older, date) %>% 
  filter(year(date) == 2022) %>% 
  filter(continent == "Europe") %>% 
  group_by(location) %>% 
  summarize(age65 = max(aged_65_older, na.rm = TRUE)) %>% 
  arrange(-age65)
  






