library(tidyverse)
library(readxl)

# Load TED Talks data set (2006 - 2021) ####
ted <- readRDS("data/ted_talks_2021/ted_2006_2021.rds")

ted |>
  glimpse()

# Preparation: Tokenize TED Talks ####

## Generate a unique ID for each talk ####

ted <- 
  ted |> 
  mutate(id = row_number(), .before = 1) |> 
  glimpse()

ted |> 
  select(id, title, transcript, published_on)

## Clean and normalize ####

ted_clean <- 
  ted |> 
  select(id, title, transcript) |> 
  drop_na() |> 
  mutate(transcript = str_to_lower(transcript)) |> 
  mutate(transcript = str_remove_all(transcript, "[[:punct:]]")) |> # remove punctuation
  mutate(transcript = str_replace_all(transcript, "\\s{2,}", " ")) |>  # replace multiple spaces with one
  mutate(transcript = str_trim(transcript))  # remove white spaces from start and end 

ted_clean

## Tokenize transcripts
ted_tokenized <- 
  ted_clean |> 
  separate_longer_delim(transcript, delim = " ") |> 
  rename(word = transcript)

ted_tokenized |> 
  count(word, sort = TRUE)

# :-( Too many useless words

## Remove stop words ####

stop <- read_excel("data/stopwords_english.xlsx")

# Let's peek
ted_tokenized |> 
  anti_join(stop) |> 
  count(word, sort = TRUE) |> 
  print(n = 100)

# Ok, let's add some additional words
more_stop <- c("not", "will", "dont", "things", "thing", "lot", "youve", "doesnt")
more_stop <- tibble(word = more_stop)
stop <- bind_rows(stop, more_stop)

# Save the result
ted_stop <- 
  ted_tokenized |> 
  anti_join(stop)

# Deductive Topic Classification (Theory-driven) ####

# Topics: Artificial Intelligence / Climate Change / Education
inductive_keywords <- 
  readxl::read_excel("data/ted_talks_2021/inductive_topics.xlsx") |> 
  mutate(weight = as.double(weight))

inductive_keywords

## Join topic dictionary with data ####
ted_stop |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T)
  
## Calculate absolute counts ####
ted_stop |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  group_by(title, topic) |> 
  mutate(num_hits = n()) |> # all counts
  mutate(num_dist_hits = n_distinct(keyword)) # distinct counts

## Calculate relative counts ####
ted_stop |> 
  group_by(title) |> 
  mutate(num_words = n()) |> 
  ungroup() |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  group_by(title, topic) |>
  mutate(num_distinct_hits = n_distinct(keyword), .before = 1) |>
  mutate(num_total_hits = n(), .before = 1) |> 
  mutate(pct_total_hits = num_total_hits / num_words, .before = 1)
  
## Calculate weighted counts ####
ted_stop |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  group_by(title, topic) |>
  mutate(num_total_hits = n(), .before = 1) |> 
  mutate(weighted_total_hits = sum(weight), .before = 1) |> 
  select(id, title, keyword, weight, weighted_total_hits, everything()) |> 
  ungroup()

## Calculate weighted distinct counts ####
ted_stop |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  distinct(id, title, keyword, weight) |> 
  group_by(id, title) |> 
  summarize(weighted_total_distinc_hits = sum(weight)) |> 
  ungroup()

## Choose class with highest score (example for relative count) ####
ted_stop |> 
  group_by(title) |> 
  mutate(num_words = n()) |> 
  ungroup() |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  group_by(title, topic) |>
  mutate(pct_total_hits = n() / num_words, .before = 1) |> 
  ungroup() |> 
  distinct(id, topic, title, pct_total_hits) |> 
  group_by(id, title) |> 
  slice_max(order_by = pct_total_hits) # get top row for each title

## Refine dictionary ####

# Look at talks that are not categorized (yet)

threshold_pct <- 0.05

ted_classified <-
  ted_stop |> 
  group_by(title) |> 
  mutate(num_words = n()) |> 
  ungroup() |> 
  inner_join(inductive_keywords, by = join_by(word == keyword), keep = T) |> 
  group_by(title, topic) |>
  mutate(pct_total_hits = n() / num_words, .before = 1) |> 
  ungroup() |> 
  distinct(id, topic, title, pct_total_hits) |> 
  group_by(id, title) |> 
  slice_max(order_by = pct_total_hits) |> 
  filter(pct_total_hits >= threshold_pct)

ted_classified

## Get only the TED talks that have no topic assigned yet ####
ted_stop |> 
  anti_join(ted_classified) |>
  inner_join(ted_clean) |> 
  distinct(id, title, transcript)

## Get only TED talks with a topic ####
ted_words_classified <- 
  ted_stop |> 
  inner_join(ted_classified) |>
  inner_join(ted_clean) |> 
  filter(topic == "Climate Change") |> 
  count(word, sort = T) |> 
  left_join(inductive_keywords, by= join_by(word == keyword)) |>
  mutate(in_dict = !is.na(topic)) |> 
  select(word, n, in_dict) |> 
  filter(n > 10)

# Create a word cloud for the words in classified talks ####
ggplot(ted_words_classified) +
  aes(label = word, size = n, color = in_dict) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 50) +
  scale_color_manual(values = c("#000000", "#009ee3")) +
  theme_light()
  



