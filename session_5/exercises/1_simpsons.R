library(tidyverse)

script_lines <- read_csv2("./data/simpsons/script_lines.csv")
locations <- read_csv("./data/simpsons//locations.csv")
characters <- read_csv("./data/simpsons/characters.csv")
episodes <- read_csv("./data/simpsons/episodes.csv")

script_lines %>% 
  glimpse()

locations %>% 
  glimpse()

characters %>% 
  glimpse()

episodes %>% 
  glimpse()

# Try to solve the questions from the SQL exercises with R:

# Part 1:
# https://analytics.datalit.de/datensaetze-und-uebungen/uebungen/sql/01-die-simpsons-teil-1

# Part 2:
# https://analytics.datalit.de/datensaetze-und-uebungen/uebungen/sql/02-die-simpsons-teil-2