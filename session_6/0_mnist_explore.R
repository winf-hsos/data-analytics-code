library(tidyverse)
library(janitor)

mnist_train <- read_csv("./data/mnist_train.csv.gz")
mnist_test <- read_csv("./data/mnist_test.csv.gz")

mnist_train %>% 
  count()

mnist_test %>% 
  count()

# What does the data look like?
mnist_train %>% 
  glimpse()

# How many samples for each label?
mnist_train %>% 
  count(label)

# What does the data for a pixel in the middle look like?
mnist_train %>% 
  count(`14x14`, sort = TRUE)

mnist_train %>% 
  select(`14x14`) %>% 
  ggplot() +
  aes(x = `14x14`) +
  geom_histogram(bins = 25)

# Pivot the data to have a pixel per row
# Convert the pixel at the same time
mnist_pivot <- mnist_train %>%
  head(1000) %>%
  mutate(instance = row_number()) %>%
  gather(pixel, value, -label, -instance) %>% 
  separate(pixel, c("x", "y"), sep = "x", remove = F) %>%
  mutate(x = 28 - as.integer(x), y = as.integer(y)) %>% 
  arrange(instance)

mnist_pivot %>% 
  count()

mnist_pivot %>% 
  tabyl(label)
  
mnist_pivot %>%
  filter(label == 9) %>% 
  head(784) %>% 
  ggplot(aes(x, y, fill = value)) +
  coord_flip() +
  geom_tile()

# Let's plot the first 16 digits
mnist_pivot %>%
  filter(instance <= 16) %>% 
  ggplot(aes(x, y, fill = value)) +
  coord_flip() +
  geom_tile() +
  facet_wrap(~ instance + label) + 
  theme(strip.text.x = element_blank(), axis.text = element_blank(), axis.ticks = element_blank())

# So what is the average pixel value for each label?
mnist_mean <- mnist_pivot %>% 
  group_by(x, y, label) %>% 
  summarize(avg = mean(value))

# This could be a filter to recognize digits...
mnist_mean %>%
  ggplot(aes(x, y, fill = avg)) +
  geom_tile() +
  scale_fill_gradient2(low = "white", high = "black", mid = "gray", midpoint = 127.5) +
  facet_wrap(~ label, nrow = 2) +
  coord_flip()

# Using this, we could identify digits that differ a lot from the average
mnist_joined <- mnist_pivot %>%
  inner_join(mnist_mean, by = c("label", "x", "y"))

distances <- mnist_joined %>%
  group_by(label, instance) %>%
  summarize(distance = sqrt(mean((value - avg) ^ 2)))

distances

# Visualize the distribution of distances
ggplot(distances, aes(factor(label), distance)) +
  geom_boxplot() +
  labs(x = "Digit",
       y = "Distance to the average digit")

# Let's look at the worst 5 instances for each digit
worst_instances <- distances %>%
  top_n(5, distance) %>%
  mutate(number = rank(-distance))

worst_instances

# Visualize them, row by row
mnist_pivot %>%
  inner_join(worst_instances, by = c("label", "instance")) %>%
  ggplot(aes(x, y, fill = value)) +
  geom_tile(show.legend = FALSE) +
  coord_flip() +
  scale_fill_gradient2(low = "white", high = "black", mid = "gray", midpoint = 127.5) +
  facet_grid(label ~ number) +
  theme_void() +
  theme(strip.text = element_blank())


# Read more:
# This analysis is heavily inspired by David Robinson's blog post on r-craft.org
# https://www.r-craft.org/r-news/exploring-handwritten-digit-classification-a-tidy-analysis-of-the-mnist-dataset/

