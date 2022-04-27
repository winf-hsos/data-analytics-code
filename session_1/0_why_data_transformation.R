library(tidyverse)
library(lubridate)
library(stringr)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")


tweets %>% 
  mutate(hour_created_at = hour(created_at), .before = 1) %>%
  mutate(ret = if_else(is_retweet == TRUE, "Ja", "Nein", missing = "NA")) %>%
  filter(created_at >= "2021-01-01", created_at <= "2022-04-30") %>%
  ggplot() +
  aes(x = hour_created_at, fill = ret) +
  geom_bar() +
  labs(x = "Stunde des Tages", y = "Anzahl Tweets", fill = "Retweet?") +
  scale_x_continuous(breaks = c(0:23)) +
  ggtitle("Tweets pro Stunde") +
  scale_fill_brewer(palette = "Paired") +
  theme_light()


tweets %>% 
  filter(created_at >= "2021-11-01", created_at <= "2022-04-18") %>% 
  mutate(text = str_to_lower(text)) %>% 
  mutate(topic = case_when(
    str_detect(text, "ukraine") ~ "Ukraine",
    str_detect(text, "corona") ~ "Corona")) %>% 
  filter(!is.na(topic)) %>% 
  mutate(day = floor_date(created_at, unit = "days")) %>% 
  group_by(topic, day) %>% 
  summarise(c = n()) %>% 
  ggplot() +
  aes(x = day, y = c, color = topic) +
  geom_line(size = 1.1) +
  labs(x = "Zeit", y = "Anzahl Tweets", color = "Thema") +
  ggtitle("Verlauf der Tweets mit Ukraine und Corona") +
  scale_colour_brewer(palette = "Pastel1") +
  theme_dark()
  
