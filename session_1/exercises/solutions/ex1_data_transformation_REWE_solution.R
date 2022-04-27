# The exercise is available online: https://analytics.datalit.de/r/uebungen/uebung-zur-datenverarbeitung

library(tidyverse)
library(tidyselect)

# 1.1: Load the REWE products data set as a tibble ✔
rewe <- read_csv("./data/rewe_products.csv")

# And now you go...
rewe
dim(rewe)[1]

rewe %>%
  select(productName) %>% 
  head(n = 20)

rewe %>%
  select(productName) %>% 
  print(n = Inf)

rewe %>% 
  select(brand) %>% 
  drop_na() %>% 
  head()

rewe %>% 
  select(brand) %>% 
  filter(!is.na(brand))

rewe %>% 
  select(productName, fatInGram) %>% 
  arrange(desc(fatInGram)) %>% 
  head(5)

rewe %>% 
  select(productName, fatInGram) %>% 
  arrange(-fatInGram) %>% 
  head(5)

rewe %>% 
  select(vegan) %>% 
  drop_na() %>% 
  head(10)

summary(rewe$vegan)
summary(rewe$fatInGram)

rewe %>% 
  select(contains("InGram"))

rewe %>% 
  select(where(is.numeric))


rewe %>% 
  select(productName, countryOfOrigin) %>% 
  filter(str_detect(countryOfOrigin, "Deutschland"))

rewe %>% 
  select(productName, countryOfOrigin) %>% 
  filter(countryOfOrigin == "Deutschland")

rewe %>% 
  select(productName, countryOfOrigin) %>% 
  filter(countryOfOrigin != "Deutschland")

rewe %>% 
  filter(vegan == TRUE)

rewe %>% 
  filter(!vegan)

rewe %>% 
  select(productName, productSubCategory, productType, price) %>% 
  filter(str_detect(productSubCategory, "Wein")) %>% 
  filter(productType == "Rotwein", price < 2)


rewe %>% 
  mutate(countryOfOrigin = str_to_lower(countryOfOrigin)) %>% 
  filter(str_detect(countryOfOrigin, "deutschland"))

rewe %>% 
  mutate(
        productId = as.character(productId), 
        gtin = as.character(gtin)
        )

rewe %>% 
  mutate(sum_nutrition = fatInGram + proteinInGram + saltInGram) %>% 
  colnames()

rewe %>% 
  mutate(sum_nutrition = fatInGram + proteinInGram + saltInGram, .before = 1, .keep = "used")

rewe %>% 
  transmute(high_fat = fatInGram > 90, fatInGram)

rewe %>% 
  count()

rewe %>% 
  summarize(num_products = n())

rewe %>% 
  count(productCategory, sort = TRUE)

rewe %>% 
  group_by(productCategory) %>% 
  summarise(num_products = n(), avg_price = mean(price)) %>% 
  arrange(-num_products)

rewe %>% 
  group_by(productCategory) %>% 
  drop_na(fatInGram) %>% 
  summarise(avg_fat = mean(fatInGram)) 

rewe %>% 
  group_by(productCategory) %>% 
  filter(!is.na(fatInGram)) %>% 
  summarise(avg_fat = mean(fatInGram)) 

rewe %>% 
  group_by(productCategory, productType) %>% 
  summarise(avg_fat = mean(fatInGram, na.rm = TRUE)) 
