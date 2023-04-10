library(tidyverse)
library(stringi)
library(stringr)

tweets <- readRDS('data/tweets_ampel.rds')

# Search in text with str_detect
tweets |> 
  filter(str_detect(str_to_lower(text), "ukraine")) |> 
  select(screen_name, text)

# Search for texts that start with something (or don't!)
tweets |> 
  filter(str_starts(text, "RT", negate = T)) |> 
  select(screen_name, text)

# The equivalent is str_ends()

# The functions take a regular expression by default
tweets |> 
  filter(str_detect(str_to_lower(text), "ukraine|covid")) |> 
  select(screen_name, text)

search <- c("Ukraine", "Verfolgung", "Moskau", "Berlin")

tweets |> 
  filter(str_detect(text, paste(search, collapse = "|"))) |>
  select(id, text) |> 
  filter(id == "1518957407845687297") |> 
  mutate(matches = str_extract_all(text, paste(search, collapse = "|"))) |> 
  select(id, matches) |> 
  unnest(matches)
  
tweets |> 
  filter(str_detect(text, paste(search, collapse = "|"))) |>
  select(id, text) |> 
  filter(id == "1518957407845687297") |> 
  mutate(matches = str_extract_all(text, paste(search, collapse = "|"))) |> 
  mutate(matches_flat = stri_join_list(matches, sep = ",")) |> 
  select(id, matches, matches_flat)


# Find the indexes of words
tweets |> 
  filter(str_detect(str_to_lower(text), "ukraine")) |> 
  select(screen_name, text)
  

# READ MORE:
# stringi: https://stringi.gagolewski.com/index.html
# stringr: https://stringr.tidyverse.org/
# stringr Reference: https://stringr.tidyverse.org/reference/index.html
# R for Data Science, Chapter 14 "Strings": https://r4ds.had.co.nz/strings.html
