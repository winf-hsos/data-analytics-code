library(jsonlite)
library(tidyverse)


# Read the JSONL file into a character vector (one line per element)
lines <- readLines("data/tweets_sample_extracted.jsonl", encoding = "UTF-8")

df <- lines  |> 
  map(fromJSON)  |>   # apply fromJSON to each row 
  tibble()  |>        # make a tibble with one column containing a named list
  unnest_wider(1)     # spread each lines with a named list into multiple columns

# extract topics in separate lines
df |> 
  unnest_longer(topics_list)

# What fromJSON does
json_str <- '{ "name":"Hans", "age": 43 }'
fromJSON(json_str)
