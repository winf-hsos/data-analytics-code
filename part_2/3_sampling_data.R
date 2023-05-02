library(tidyverse)

tweets <- readRDS('data/tweets_ampel.rds')

# Sample 10 % of the total data
tweets |> 
  slice_sample(prop = 0.1)

# Sample 1000 tweets
tweets |> 
  slice_sample(n = 1000)