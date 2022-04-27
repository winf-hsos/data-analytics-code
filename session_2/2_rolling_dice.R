library(tidyverse)

# The number of dice rolls
n <- 1000

s <- sample(c(1, 2, 3, 4, 5, 6), n, replace = TRUE)
s <- enframe(x = s, value = "roll", name = NULL)

# Show as bar chart
ggplot(s) +
  aes(x = factor(roll)) + 
  geom_bar(fill = "#009ee3")  +
  theme_light() +
  xlab("Result") +
  ylab("Count") +
  ggtitle(paste("n = ", n))