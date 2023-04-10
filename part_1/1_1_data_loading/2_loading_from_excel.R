library(tidyverse)
library(readxl)

tweets_meta <- read_excel("./data/tweets_metadata.xlsx")
tweets_meta %>% 
  glimpse()

# Same from here...

# What could be the problem with XLSX in a collaborative environment?