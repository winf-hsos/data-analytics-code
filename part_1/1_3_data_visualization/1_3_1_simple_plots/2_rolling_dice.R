library(tidyverse)

# The number of samples
n <- 10

# SAMPLING FROM A DISCRETE DISTRIBUTION (DICE ROLL) ####

s <- sample(c(1, 2, 3, 4, 5, 6), n, replace = TRUE)

# Make a tibble
s <- enframe(x = s, value = "roll", name = NULL)

# Show as bar chart
ggplot(s) +
  aes(x = factor(roll)) + 
  geom_bar(fill = "#009ee3")  +
  theme_light() +
  xlab("Result") +
  ylab("Count") +
  ggtitle(paste("n = ", n))

# SAMPLING FROM NORMAL DISTRIBUTION #####

n <- 10

# The same for the normal distribution (continuous)
sample <- rnorm(n, 0, 1)

# Make a tibble
sample <- enframe(x = sample, value = "v", name = NULL)

# Show a histogram
ggplot(sample) +
  aes(x = v) +
  geom_histogram(binwidth = 0.05, fill = "#009ee3")