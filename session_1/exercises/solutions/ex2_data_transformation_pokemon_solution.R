library(tidyverse)

# Load the data as a tiblle
pokemon <- read_csv("./data/pokemon.csv")

# 1. Get a quick overview of the data set! How can you do that?

glimpse(pokemon)

pokemon %>% 
  select(where(is.numeric)) %>% 
  summary()

# 2. Convert the column "is_legendary" to a logical data type! Save the result!

pokemon %>% 
  select(is_legendary)

pokemon <-
  pokemon %>% 
  mutate(is_legendary = as.logical(is_legendary))

# 3. Print all legendary pokemons! How many are there?

pokemon %>% 
  filter(is_legendary) %>% 
  select(name) %>% 
  arrange(name)

pokemon %>% 
  filter(is_legendary) %>% 
  count()

# 4. Extract all columns that start with "against_"!

pokemon %>% 
  select(starts_with("against_"))

# 5. Rename the column "classfication" into "classification"!

pokemon <- 
  pokemon %>% 
  rename(classification = classfication)

glimpse(pokemon)

# 6. Which group of type1 of pokemons has the highest average attack value? 
#    Additionally, show the number of pokemons in each class! 

pokemon %>% 
  group_by(type1) %>% 
  summarise(avg_attack_rate = mean(attack), num_pokemon = n()) %>% 
  arrange(-avg_attack_rate)

# 7. Do legendary pokemon weigh more than others?

pokemon %>% 
  group_by(is_legendary) %>% 
  summarise(avg_weight = mean(weight_kg, na.rm = TRUE))

# 8. What is the largest generation for a pokemon in the data set?

pokemon %>% 
  summarise(max_gen = max(generation))

# 9. Which type of pokemon is the fastest on average?

pokemon %>% 
  group_by(type1) %>% 
  summarise(avg_speed = mean(speed)) %>% 
  arrange(-avg_speed)

# 10. Which pokemon has the largest height to weight ratio?

pokemon %>% 
  mutate(height_weight_ratio = height_m / weight_kg) %>% 
  select(name, height_weight_ratio) %>% 
  arrange(-height_weight_ratio)