library(tidyverse)

tweets <- readRDS('data/tweets_ampel.rds')

# 1. Filter out irrelevant records for a smaller data set ####
tweets_filtered <- 
  tweets |> 
  filter(year(created_at) == 2023) |> 
  filter(lang == "de") |> 
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
  rename(word = text) |> 
  select(id, screen_name, created_at, word)

# Count word frequencies
tweets_tokenized |> 
  count(word, sort = T)

# 4. Filter out common stopwords ####

# Load a table with stop words
stop <- read_csv("data/stopwords_german.csv")

# Use anti-join to filter
tweets_tokenized |> 
  anti_join(stop, by ="word") |>
  filter(str_length(word) > 2) |> # Words must be at least 3 letters long
  count(word, sort= T) 


# Filter on word that appear at least 20 times
tweets_tokenized |> 
  anti_join(stop, by ="word") |>
  filter(str_length(word) > 2) |> # Words must be at least 3 letters long
  count(word, sort= T) |> 
  filter(n > 20)

# Add more words to stop word list
stop <- read_csv("data/stopwords_german.csv")
added_stopwords <- tibble(word = c("tb", "cl", "bm3", "bm"))

# Combine the new tibble with your existing tibble
stop <- bind_rows(stop, added_stopwords)
stop |>  
  tail(20)

# Alternative 1: Edit the CSV file

# Alternative 2: Use Google Sheets and load stop words from there

# Build the URL from sheet ID and sheet name
# https://docs.google.com/spreadsheets/d/1t-7NDGbrqj1r-4RyaSPMUEQyAd_oN5_GRWwR8S2nHrE/edit#gid=0

sheet_id <- "1t-7NDGbrqj1r-4RyaSPMUEQyAd_oN5_GRWwR8S2nHrE"
sheet_name <- "stopwords"
sheet_url <- paste0("https://docs.google.com/spreadsheets/d/", sheet_id, "/gviz/tq?tqx=out:csv&sheet=", sheet_name)


stop_from_sheets <- read_csv(sheet_url)
stop_from_sheets |> 
  count()

# 5. POS / Stemming ####

# Coming soon.





