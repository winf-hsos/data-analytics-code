# This script contains examples for the facets layer in ggplot2

library(tidyverse)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# Load the tweets
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Load REWE data
rewe <- read_csv("./data/rewe_products.csv")


# Load the limonade survey data
limonade <- read_csv("./data/limonade.csv")

# facet_wrap() for one small plot per study program
limonade %>%
  transmute(alter = 2022 - f39_geburtsjahr, studiengang = as.factor(f44_studiengang)) %>%
  filter(alter < 100 & studiengang != "-999") %>%
  
  ggplot(aes(x = alter, y = ..density..)) +
  geom_histogram(binwidth = 10, color="#000000", fill="#009ee3", alpha = 0.8) +
  facet_wrap(~studiengang, ncol = 3)

# facet_wrap() with density plots
limonade %>%
  transmute(alter = 2021 - f39_geburtsjahr, studiengang = as.factor(f44_studiengang)) %>%
  filter(alter < 100 & studiengang != "-999") %>%
  
  ggplot(aes(x = alter, y = ..density..)) +
  geom_density(color="black", fill="#009ee3", alpha = 0.8) +
  facet_wrap(vars(studiengang), ncol = 2) +
  theme_bw()

tweets %>% 
  filter(year(created_at) == 2022) %>% 
  mutate(created_day = floor_date(created_at, unit = "weeks")) %>% 
  count(screen_name, created_day) %>% 
  
  ggplot() +
  aes(x = created_day, y = n) +
  geom_line() +
  facet_wrap(~screen_name)

# excursion: ridgeline plots
# Ridgeline Plots
#install.packages("ggridges")
library(ggridges)

limonade %>%
  transmute(alter = 2021 - f39_geburtsjahr, studiengang = as.factor(f44_studiengang)) %>%
  filter(alter < 100 & studiengang != "-999") %>%
  ggplot() +
  aes( x = alter, y = studiengang, fill = studiengang ) +
  geom_density_ridges(alpha = 0.7) +
  
  # Add axis titles
  xlab("Age") +
  ylab("Study Program") +
  
  theme_light() +
  # Remove the legend
  theme(legend.position = "none")
