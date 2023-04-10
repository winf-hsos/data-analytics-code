#install.packages("tidyverse")

library(tidyverse)
library(lubridate)
library(stringr)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

tweets |>
  mutate(hour_created_at = hour(created_at), .before = 1) |>
  mutate(ret = if_else(is_retweet == TRUE, "Yes", "No", missing = "NA")) |>
  filter(created_at >= "2021-01-01", created_at <= "2022-04-30") |>
  ggplot() +
  aes(x = hour_created_at, fill = ret) +
  geom_bar() +
  labs(x = "Hour of the day", y = "Number tweets", fill = "Is retweet?") +
  scale_x_continuous(breaks = c(0:23)) +
  ggtitle("Tweets per hour") +
  scale_fill_brewer(palette = "Paired") +
  theme_light()


tweets |>
  filter(created_at >= "2021-10-01", created_at <= "2022-09-30") |>
  mutate(text = str_to_lower(text)) |>
  mutate(topic = case_when(
    str_detect(text, "ukraine|russland|krieg") ~ "Ukraine",
    str_detect(text, "corona|covid|pandemie") ~ "Corona"
  )) |>
  filter(!is.na(topic)) |>
  mutate(day = floor_date(created_at, unit = "days")) |>
  group_by(topic, day) |>
  summarise(c = n()) |>
  
  ggplot() +
  aes(x = day, y = c, color = topic) +
  geom_line(size = 0.9) +
  labs(x = "Zeit", y = "Number tweets", color = "Topic") +
  ggtitle("Development of tweets about Ukraine and Corona") +
  scale_colour_brewer(palette = "Set1") +
  theme_minimal()
