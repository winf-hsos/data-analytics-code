library(tidyverse)

tweets_classified <- read_csv("data/tweets_sample_classified.csv")

tweets_classified |> 
  count(is_ukraine)
