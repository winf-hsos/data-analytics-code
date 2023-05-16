library(tidyverse)

# Link to original source: https://www.kaggle.com/datasets/thedatabeast/ted-talk-transcripts-2006-2021

# Load TED Talks data set (2006 - 2021) ####
transcripts_gz <- gzfile("data/ted_talks_2021/transcript_data.csv.gz")
transcripts <- read_csv(transcripts_gz)

multiple_titles <- transcripts |> 
  count(title, sort = T) |> 
  filter (n > 1) |> 
  select(title) |> 
  pull()

transcripts <- transcripts |> 
  filter(!title %in% multiple_titles)

# Join talk meta data ####
talk_data_gz <- gzfile("data/ted_talks_2021/talk_data.csv.gz")
talk_data <- read_csv(talk_data_gz)

talk_data <- 
  talk_data |> 
  left_join(transcripts, by = join_by(talk_name == title)) |> 
  rename(title = talk_name)

# Join speaker data ####
speaker_data_gz <- gzfile("data/ted_talks_2021/speaker_data.csv.gz")
speaker_data <- read_csv(speaker_data_gz)

speaker_data <- 
  speaker_data |> 
  filter(!talk %in% multiple_titles, !is.na(talk))

talk_data <- 
  talk_data |> 
  left_join(speaker_data, by = join_by(title == talk))

# Convert and rename "published_on" column ####
talk_data <- 
  talk_data |>
  mutate(`published on` = as_datetime(`published on`)) |>
  rename(published_on = `published on`)

# Save as RDS file ####
saveRDS(talk_data, "data/ted_talks_2021/ted_2006_2021.rds")
