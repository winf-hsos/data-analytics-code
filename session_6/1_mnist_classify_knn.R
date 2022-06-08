#install.packages("tidymodels")
#install.packages("kknn")

library(tidyverse)
library(janitor)

library(tidymodels)
tidymodels_prefer()

library(kknn)

mnist_train <- read_csv("./data/mnist_train.csv.gz") 
mnist_test <- read_csv("./data/mnist_test.csv.gz")

# Draw a sample from the training data to speed up the fitting
mnist_train_sample <- mnist_train %>% 
  sample_n(1000) %>% 
  mutate(label = factor(label))

mnist_test_sample <- mnist_test %>% 
  sample_n(500) %>% 
  mutate(label = factor(label))

# Setup the classifier
knn_classifier <-
  nearest_neighbor(neighbors = 10, weight_func = "triangular") %>%
  set_mode("classification") %>%
  set_engine("kknn")

knn_classifier

# Fit the classifier
knn_classifier_fit <- knn_classifier %>% 
  fit(label ~ ., data = mnist_train_sample)

knn_classifier_fit

# Evaluate the test set
eval <- bind_cols(
  predict(knn_classifier_fit, mnist_test_sample),
  predict(knn_classifier_fit, mnist_test_sample, type = "prob"),
  select(mnist_test_sample, label)
) %>% rename(prediction = .pred_class)

eval

eval %>% 
  mutate(correct = prediction == label) %>% 
  tabyl(correct)

eval %>% 
  accuracy(truth = label, prediction)

eval %>% 
  conf_mat(truth = label, prediction)

# READ MORE
# Book: Kuhn, M., Silge, J.: Tidy Modeling with R
# URL: https://www.tmwr.org/
