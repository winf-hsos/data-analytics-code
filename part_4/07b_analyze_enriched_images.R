library(tidyverse)

tweets_analyzed <- read_csv("data/tweets_img_analyzed.csv", col_types = cols(id = col_character()))
tweets_analyzed |>  
  glimpse()
