library(tidyverse)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")


# 1. Become familiar with the new data set. What are your steps?

# How many rows and columns?
dim(covid)

covid %>% glimpse()

# Date range?
covid %>% 
  select(date) %>% 
  summary()

install.packages("mosaic")
library(mosaic)

install.packages("skimr")
library(skimr)

covid %>% 
  skim() %>% 
  count(skim_type)

skim(covid) %>% 
  select(skim_variable,complete_rate) %>% 
  arrange(complete_rate) %>% 
  print(n = 100)


# 2. Do some data quality checks! What queries do you use?

# 3. Generate at least 5 questions and iteratively cycle through transformation and
# visualization to find signals that lead you to a hypotheses!

# 4. Create further analysis to find more evidence for your hypotheses!