library(tidyverse)
library(ggwordcloud)

words <- c("data", "ai", "cloud", "digitalization")
mentions <- c(15, 5, 2, 7)
data <- tibble(word = words, n = mentions)

ggplot(data) +
  aes(label = word, size = n, color = n) +
  geom_text_wordcloud_area() +
  theme_light() +
  scale_size_area(max_size = 45)
