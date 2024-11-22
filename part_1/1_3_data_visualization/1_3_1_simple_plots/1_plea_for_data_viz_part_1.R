library(tidyverse)

some_data <- read_csv("data/some_data.csv")

some_data |> 
  print(n = 200)

mean(some_data$x)
mean(some_data$y)

sd(some_data$x)
sd(some_data$y)

cor(some_data$x, some_data$y)

ggplot(some_data) +
  aes(x, y) +
  geom_point()

# Credits to Alberto Cairo