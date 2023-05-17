library(tidyverse)

named_ents <- read_csv("data/ted_talks_2021/named_entities.csv.gz")

named_ents |> 
  glimpse()

named_ents |> 
  count(entity_label, sort = TRUE)

named_ents |> 
  count(entity_text, entity_label, sort = TRUE) |> 
  filter(entity_label %in% c("PERSON")) |>
  print(n = 100)


# Which people are mentioned in each talk?
transcripts <- readRDS("data/ted_talks_2021/ted_2006_2021.rds")

transcripts |> 
  glimpse()

transcripts |> 
  inner_join(named_ents, relationship = "many-to-many") |> 
  filter(entity_label == "PERSON") |> 
  select(title, entity_text, published_on)

# How many talks mention Bill Gates over time?
transcripts |> 
  inner_join(named_ents, relationship = "many-to-many") |> 
  filter(entity_label == "PERSON") |>
  filter(entity_text == "Bill Gates") |> 
  mutate(year = floor_date(published_on, unit = "years")) |> 
  select(title, entity_text, year) |> 
  count(title, year) |> 
  arrange(year) |>

  ggplot() + 
  aes(x = year) +
  geom_bar() +
  scale_y_continuous(breaks =  c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)) +
  theme_bw()
    
