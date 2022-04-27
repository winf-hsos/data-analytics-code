library(tidyverse)

some_data <- read_csv("./data/some_data.csv")

some_data

ggplot(some_data) +
  aes(x, y) +
  geom_point()