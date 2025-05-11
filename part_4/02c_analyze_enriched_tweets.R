library(tidyverse)

tweets_classified <- read_csv("data/tweets_sample_classified.csv", col_types = cols(id = col_character()))

tweets_classified |> 
  glimpse()

tweets_classified |> 
  count(is_ukraine)

# Join with original tweets
tweets <- readRDS("data/tweets_ampel.rds")

tweets |> 
  left_join(tweets_classified, by = join_by(id == id)) |> 
  drop_na(is_ukraine)
