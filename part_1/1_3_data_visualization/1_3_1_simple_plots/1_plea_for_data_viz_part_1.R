library(tidyverse)

some_data <- read_csv("data/some_data.csv")

some_data |> 
  print(n = 142)

ggplot(some_data) +
  aes(x, y) +
  geom_point()

# Credits to Alberto Cairo