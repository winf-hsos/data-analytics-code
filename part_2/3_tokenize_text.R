library(tidyverse)

tweets <- readRDS('data/tweets_ampel.rds')

# 1. Filter out irrelevant records for a smaller data set ####
tweets_filtered <- 
  tweets |> 
  filter(year(created_at) == 2023) |> 
  filter(lang = "de") |> 
  select(id, created_at, screen_name, text, is_retweet)

tweets_filtered

# 2. Clean and normalize text ####
tweets_clean <-
  tweets_filtered |> 
  mutate(original_text = text) |>  # save original text for comparison
  mutate(text = str_to_lower(text)) |> # make lowercase
  mutate(text = str_remove_all(text, "@\\w+")) |> # remove user mentions
  mutate(text = str_remove_all(text, "#\\w+")) |>  # remove hashtags
  mutate(text = str_remove_all(text, "https?://\\S+")) |>  # remove URLs
  mutate(text = str_remove_all(text, "[[:punct:]]")) |> # remove punctuation
  mutate(text = str_replace_all(text, "\\s{2,}", " ")) |>  # replace multiple spaces with one
  mutate(text = str_trim(text))  # remove white spaces from start and end 
  
tweets_clean |> 
  select(text, original_text)

# 3. Tokenize using space as a delimiter ####
tweets_tokenized <- tweets_clean |> 
  tidyr::separate_longer_delim(text, " ") |> 
  select(id, screen_name, text)

# Count word frequencies
tweets_tokenized |> 
  count(text, sort = T)

# 4. Filter out common stopwords ####





