library(tidyverse)
library(janitor)

library(tidymodels)
tidymodels_prefer()
library(keras)

# Create an artificial data set where y = a + b
a <- runif(10000, 0, 10)
b <- runif(10000, 0, 10)
y <- a + b

# Make a tibble from it
data <- tibble(a, b, y)

# Split into training and test data sets
set.seed(42)
split_data <- initial_split(data, prop = 0.9)
train_data <- training(split_data)
test_data <- testing(split_data)

train_data %>% count()
test_data %>% count()

# Linear regression
lm_reg <- linear_reg(mode = "regression", engine = "lm", penalty = NULL, mixture = NULL)

lm_reg

# Fit the lm model
lm_reg_fit <- lm_reg %>% 
  fit(y ~ ., data = train_data)

lm_reg_fit

# Evaluate the trained lm model with the test data
eval <- bind_cols(
  predict(lm_reg_fit, test_data),
  select(test_data, y)
) %>% rename(prediction = .pred)

# Root mean squared error
eval %>% 
  rmse(truth = y, estimate = prediction)

# Pearson R
eval %>% 
  rsq(truth = y, estimate = prediction)

# Evaluate data outside the training data's range
new_data <- tibble(a = 100, b = 200)
predict(lm_reg_fit, new_data)

## The same with a ANN

nn_reg <- 
  mlp(epochs = 20, learn_rate = 0.01, hidden_units = 20, activation = "relu") %>% 
  set_mode("regression") %>% 
  set_engine("keras")

nn_reg_fit <- nn_reg %>% 
  fit(y ~ ., data = train_data)

nn_reg_fit

# Evaluate the trained ANN with the test data
eval <- bind_cols(
  predict(nn_reg_fit, test_data),
  select(test_data, y)
) %>% 
  rename(prediction = .pred)

eval

# Root mean squared error
eval %>% 
  rmse(truth = y, estimate = prediction)

# Pearson R
eval %>% 
  rsq(truth = y, estimate = prediction)

# Evaluate data outside the training data's range
new_data <- tibble(a = 100, b = 200)
predict(nn_reg_fit, new_data)

