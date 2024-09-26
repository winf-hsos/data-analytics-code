# Create a vector element by element
weight <- c(91, 75.5, 61, 88.5, 120)

# Get the storage mode of the vector
mode(weight)

# Get the type of the vector
typeof(weight)

# Get the class of the vector
class(weight)

# Get the length of the vector
length(weight)

# Summarize values
mean(weight)
range(weight)
sd(weight)
max(weight)
min(weight)

# Create a summary of the vector
summary(weight)

# Create a vector with weights after diet
weight_after_diet <- 
  c(89.5, 75, 56, 96.5, 115)

# Calculate the difference between the two vectors
weight_loss <- weight - weight_after_diet

# Check the result
weight_loss

# Mean vs. median
mean(weight_loss)
median(weight_loss)
