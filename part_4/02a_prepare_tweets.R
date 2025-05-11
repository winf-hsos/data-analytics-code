library(tidyverse)
tweets <- readRDS("data/tweets_ampel.rds")

tweets |> 
  slice_sample(n = 3) |> 
  select(id, screen_name, text) |> 
  write_csv("data/tweets_sample.csv")
