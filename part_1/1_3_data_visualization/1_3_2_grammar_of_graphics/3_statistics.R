# This script contains examples for the statistics layer in ggplot2.

library(tidyverse)
library(lubridate)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# Load the tweets
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Statistics are linked to geometries and vice versa
# So they can be used interchangeably

# stat_count() uses bars as geometry
tweets |>
  filter(year(created_at) == 2022) |> 
  ggplot() + 
  stat_count(aes(x = screen_name))

# geom_bar() uses stat_count as statistic
tweets |>
  filter(year(created_at) == 2022) |> 
  ggplot() + 
  geom_bar(aes(x = screen_name))

tweets |> 
  filter(year(created_at) == 2022) |> 
  count(screen_name) |> 
  ggplot(aes(x = screen_name, y = n)) +
  geom_col()
