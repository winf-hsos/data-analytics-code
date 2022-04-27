library(tidyverse)
library(lubridate)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Extract the hour from the created_at field
tweets_with_hour <- 
  tweets %>% 
  filter(screen_name == "OlafScholz") %>% 
  mutate(hour = factor(hour(created_at)))

tweets_per_hour <-
  tweets_with_hour %>% 
  count(hour)

# geom_col requires a column with the numbers to plot
ggplot(tweets_per_hour) +
  aes(x = hour, y = n) + 
  geom_col()

# geom_bar per default counts
ggplot(tweets_with_hour) +
  aes(x = hour) +
  geom_bar()
  

# With relative numbers
tweets_per_hour_pct <-
  tweets_per_hour %>% 
  mutate(pct = n / sum(n))

# geom_col requires a column with the numbers to plot
ggplot(tweets_per_hour_pct) +
  aes(x = hour, y = pct) + 
  geom_col() +
  scale_y_continuous(labels=scales::percent)



  
