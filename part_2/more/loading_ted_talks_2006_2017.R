library(tidyverse)

# Read the spoken text as transcripts ####
ted_text_gz <- gzfile("data/ted_talks_2017/ted_text.csv.gz")
ted_text <- read_delim(ted_text_gz, delim = ",", escape_backslash = TRUE)

# Read the TED talk meta data ####
ted_meta_gz <- gzfile("data/ted_talks_2017/ted_meta.csv.gz")
ted_meta <- read_delim(ted_meta_gz, delim = ",", escape_backslash = TRUE)

ted_meta <-
  ted_meta |>
  mutate(film_date = floor_date(as_datetime(film_date), unit = "days")) |> 
  mutate(published_date = floor_date(as_datetime(published_date), unit = "days"))

# Read the TED talk ratings ####
ted_ratings_gz = gzfile("data/ted_talks_2017/ted_ratings.csv.gz")
ted_ratings <- read_csv(ted_ratings_gz)

# Read the TED talk tags ####
ted_tags_gz <- gzfile("data/ted_talks_2017/ted_tags.csv.gz")
ted_tags <- read_csv(ted_tags_gz)