library(tidyverse)

pos <- read_csv("data/ted_talks_2021/pos.csv.gz")

pos |> 
  glimpse()

# What are the stop words by frequency?
pos |> 
  filter(is_stop) |> 
  count(token_lemma, sort = TRUE)

# What types of words appear most frequent that are not stop words?
pos |> 
  filter(!is_stop) |> 
  count(token_pos, sort = TRUE)

# Print the top 100 nouns over all talks
pos |> 
  filter(!is_stop) |> 
  filter(token_pos %in% c("NOUN")) |> 
  count(token_lemma, token_pos, sort = TRUE) |> 
  print(n = 100)
