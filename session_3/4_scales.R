# This script contains examples for the scales layer in ggplot2.

library(tidyverse)
library(lubridate)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# Load the tweets
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Choose one language for time names (March vs März etc.)
Sys.setlocale("LC_TIME", "English")
Sys.setlocale("LC_TIME", "German")

covid_ger_vacc <- covid %>%
  select(date, location, new_vaccinations_smoothed) %>%
  filter(location == "Germany") %>%
  filter(date >= "2021-01-01") %>%
  arrange(date)

ggplot(covid_ger_vacc) +
  aes(x = date, y = new_vaccinations_smoothed) +
  geom_line(color = "#009ee3", size = 1.0) +
  
  # Change the x-axis of type date
  scale_x_date(name = "Date", date_breaks = "3 month", date_labels = "%B %Y") +
  
  # Change the y-axis of type continuous
  scale_y_continuous(n.breaks = 10, labels = function(x) format(x, big.mark = ".", scientific = FALSE)) +
  
  # Some additional labels and theming
  ylab("New  vaccinations (smoothed)") +
  ggtitle("New vaccinations per day in Germany in 2021") +
  theme_light()



