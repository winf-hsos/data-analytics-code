library(tidyverse)
library(janitor)

library(tidymodels)
tidymodels_prefer()

#install.packages("tensorflow")
#library(tensorflow)
#install_tensorflow()

#install.packages("keras")
library(keras)

mnist_train <- read_csv("./data/mnist_train.csv.gz") 
mnist_test <- read_csv("./data/mnist_test.csv.gz")

# Draw a sample from the training data to speed up the fitting
mnist_train_sample <- mnist_train %>% 
  sample_n(20000) %>% 
  mutate(label = factor(label)) %>% 
  mutate(across(`1x1`:`28x28`, ~ .x / 255))

mnist_train_sample

mnist_test_sample <- mnist_test %>% 
  sample_n(10000) %>% 
  mutate(label = factor(label)) %>% 
  mutate(across(`1x1`:`28x28`, ~ .x / 255))

mnist_test_sample

# What are the best parameters?
# -----------------------------
# epochs = How many times should the data be shown to the ANN?
# learn_rate = How much should weights be adjusted in every epoch?
# hidden_units = How many neurons are there in the hidden layer?
# activation = How do the inputs activate the neurons?

nn_classifier <- 
  mlp(epochs = 40, learn_rate = 0.01, hidden_units = 10, activation = "relu") %>% 
  set_mode("classification") %>% 
  set_engine("keras")

nn_classifier

# Fit the model (train)
set.seed(1)
nn_classifier_fit <- nn_classifier %>% 
  fit(label ~ ., data = mnist_train_sample)

nn_classifier_fit

# Evaluate the trained ANN with the test data
eval <- bind_cols(
  predict(nn_classifier_fit, mnist_test_sample),
  select(mnist_test_sample, label),
  #predict(nn_classifier_fit, mnist_test_sample, type = "prob")
) %>% 
  rename(prediction = .pred_class)

eval

eval %>% 
  mutate(correct = prediction == label) %>% 
  tabyl(correct)

eval %>% 
  accuracy(truth = label, prediction)

eval %>% 
  conf_mat(truth = label, prediction)

# READ MORE
# https://parsnip.tidymodels.org/reference/mlp.html
