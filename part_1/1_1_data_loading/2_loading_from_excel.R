#### Load data from Microsoft Excel ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# 1. Install required packages (only once) ####
install.packages("readxl")

library(readxl)

tweets_meta <- read_excel("data/tweets_metadata.xlsx")

# 2. Fix the column names ####
install.packages("janitor")

library(janitor)

tweets_meta <- tweets_meta |> 
  clean_names()

tweets_meta |>  
  glimpse()
