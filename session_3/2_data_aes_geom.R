# This script contains examples for simple visualizations with ggplot2.
# The point is to show how fast we can create visualizations if we only
# specify 3 items: 
#
# (1) data
# (2) aesthetics mapping and 
# (3) geometry 
#
# Everything else has useful defaults!

library(tidyverse)
library(lubridate)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# Load the tweets
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Load REWE data
rewe <- read_csv("./data/rewe_products.csv")


# 1. geom_line() ####

covid %>%
  filter(location == "World") %>%
  select(date, new_cases_smoothed_per_million) %>%
  
  # The transformed data is piped into ggplot() function
  ggplot() +
  aes(x = date, y = new_cases_smoothed_per_million) +
  geom_line()

## Using color, linetype, and size aesthetics (a bit overplotting here)

covid %>%
  filter(location %in% c("Germany", "Austria", "Switzerland"),
         year(date) == 2022,
         !is.na(new_cases_smoothed_per_million)
         ) %>%
  select(date, location, new_cases_smoothed_per_million, population) %>%
  group_by(location) %>%
  mutate(pop = max(population)) %>% 
  ungroup() %>% 
  
  ggplot() +
  aes(x = date, 
      y = new_cases_smoothed_per_million
     ,color = location # color mapped to location,
     ,linetype = location # line type mapped to location, too
     ,size = pop # line size mapped to population
      ) +
  geom_line()


# 2. geom_point ####

# mapping color and size to the data
tweets %>% 
  filter(year(created_at) == 2022) %>% 
  filter(screen_name == "c_lindner") %>%
  filter(!is_retweet) %>%
  mutate(has_photo = lengths(photos) > 0) %>% 
  mutate(num_hashtags = lengths(hashtags)) %>% 

  ggplot() +
  aes(x = created_at, 
      y = retweet_count
     ,color = has_photo
     ,fill = has_photo
     ,size = num_hashtags
     ) +
  geom_point(alpha = 0.7, stroke = 1.2, shape = 21)


# geom_point -> use alpha with many points
# geom_smooth -> adds an trend line (here linear estimation)
rewe %>% 
  select(fatInGram, energyInKcal) %>%
  drop_na() %>% 
  ggplot() + 
  aes(x = fatInGram, y = energyInKcal) +
  geom_point(alpha = 0.05, size = 2.5, color = "#009ee3") +
  geom_smooth(se = TRUE, color = "#000000", method = "lm", size = .5) +
  ylim(0, 1000)


# 3. geom_bar ####

# bar plot with groups (fill aesthetic)
tweets %>% 
  filter(year(created_at) == 2021) %>% 
  mutate(month = factor(month(created_at))) %>% 
  
  ggplot() +
  aes(x = month, fill = is_retweet)  +
  geom_bar(position = "stack") 

# % stacked bar chart
tweets %>% 
  filter(year(created_at) == 2021) %>% 
  mutate(month = factor(month(created_at))) %>% 
  
  ggplot() +
  aes(x = month, fill = is_retweet)  +
  geom_bar(position = "fill") 

# dodged bar chart
tweets %>% 
  filter(year(created_at) == 2021) %>% 
  mutate(month = factor(month(created_at))) %>% 
  
  ggplot() +
  aes(x = month, fill = is_retweet)  +
  geom_bar(position = "dodge")


rewe %>% 
  filter(!is.na(productCategory)) %>%
  
  ggplot() +
  aes(x = fct_rev(fct_infreq(productCategory))) %>% 
  geom_bar() +
  coord_flip() +
  xlab("Category") +
  ylab("Number Products")
  # theme(axis.text.x = element_text(angle = -45, hjust = 0))

# Alternative: pre-computed counts and average price and then use geom_col
rewe %>%
  filter(!is.na(productCategory)) %>%
  group_by(productCategory) %>%
  summarise(count = n(), avg_price = mean(price)) %>%
  mutate(productCategory = fct_reorder(productCategory, count)) %>%
  
  ggplot(aes(x = count, y = productCategory, fill = avg_price)) +
  geom_col() +
  labs(x = "Number Products", y = "Product Category", fill = "Avg. Price")

bio_colors <- c("#009ee3", "darkgray")
rewe %>%
  filter(!is.na(productCategory)) %>%
  mutate(bio = as.integer(bio)) %>%
  mutate(bio = recode(bio, `1` = "Ja", `0` = "Nein")) %>%
  
  ggplot(aes(x = fct_infreq(productCategory), fill = bio)) + 
  geom_bar(width = 0.7) +
  theme(axis.text.x = element_text(angle = -45, hjust = 0)) +
  labs(fill = "Bio", y = "Number Products", x = "Product Category") +
  scale_fill_manual(values = bio_colors)

# Read more on bar chart variants:
# https://r-graph-gallery.com/48-grouped-barplot-with-ggplot2.html
