library(tidyverse)

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# 1. Become familiar with the new data set. What are your steps?

colnames(covid)

glimpse(covid)

view(covid)

str(covid)

# 2. Do some data quality checks! What queries do you use?

covid %>% 
  select(new_vaccinations) %>% 
  filter(!is.na(new_vaccinations)) %>% 
  count()

library(skimr)
skim(covid) %>% 
  select(skim_variable, n_missing, complete_rate) %>% 
  arrange(complete_rate)

# 3. Generate at least 5 questions and iteratively cycle through transformation and
# visualization to find signals that lead you to a hypotheses!

# 4. Create further analysis to find more evidence for your hypotheses!


# Wie viele Wellen gab es in D und wann waren diese?
covid %>% 
  filter(location == "Germany") %>% 
  select(date, new_cases_smoothed) %>%
  
  ggplot() +
  aes(x = date, y = new_cases_smoothed) +
  geom_smooth(span = 0.1) +
  geom_line()

  
covid %>% 
  filter(location %in% c("Germany", "France", "Austria", "Switzerland")) %>% 
  select(date, location, new_cases_smoothed_per_million) %>% 
  
  ggplot() +
  aes(x = date, y = new_cases_smoothed_per_million) +
  geom_smooth(span = 0.1) +
  geom_line() +
  facet_wrap(~location)

covid %>% 
  distinct(location) %>% 
  print(n = Inf)
  
# Wie hoch war die KH-Auslastung während der Wellen?

covid %>% 
  colnames()

covid %>% 
  filter(location == "Germany") %>% 
  select(date, icu_patients) %>% 
  ggplot() +
  aes(x = date, y = icu_patients) +
  geom_line()


covid %>% 
  filter(location == "Germany") %>% 
  select(date, icu_patients) %>% 
  filter(!is.na(icu_patients))

covid %>% 
  filter(location == "Germany") %>% 
  filter(date >= "2020-03-20", date <= "2020-07-01") %>% 
  select(icu_patients) %>% 
  
  ggplot() +
  aes(x = icu_patients) +
  geom_boxplot() +
  coord_flip()


# TODO: Punktewolke
covid %>% 
  filter(location == "Germany") %>% 
  filter(date >= "2020-03-20", date <= "2020-07-01") %>% 
  select(icu_patients) %>% 
  
  ggplot() +
  aes(x = icu_patients) +
  geom_jitter()

