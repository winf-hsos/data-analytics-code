# Introduction to vectors ####

# Create a vector element by element ####
weight <- c(91, 75.5, 61, 88.5, 120)

# Summarizing vectors ####

## Get the storage mode of the vector ####
mode(weight)

## Get the type of the vector ####
typeof(weight)

## Get the class of the vector ####
class(weight)

## Get the length of the vector ####
length(weight)

## Calculate statistical measures ####
mean(weight)
range(weight)
sd(weight)
max(weight)
min(weight)

## Mean vs. median ####
mean(weight_loss)
median(weight_loss)


## Create a summary of the vector ####
summary(weight)

# Create a vector with weights after diet ####
weight_after_diet <- 
  c(89.5, 75, 56, 96.5, 115)

## Subtract two vectors ####
weight_loss <- weight - weight_after_diet

# Subsetting vectors ####

## By index ####
weight[1]
weight[-1]

## By index range ####
weight[2:5]
weight[1:length(weight)-1]

## Using logical vectors ####
weight[c(TRUE, FALSE, TRUE, TRUE, FALSE)]

## Using comparison operators ####
weight[weight > 80]

## Using multiple conditions ####
weight[weight > 80 & weight < 100]

# Special values ####

## NA ####

# Assign an NA value to the third element
weight_with_na <- c(91, 75.5, NA, 88.5, 120)

# Extract non-NA values
weight_with_na[!is.na(weight_with_na)]

# Check for NA values
is.na(weight_with_na)

# Replace NA values with 0
weight_with_na[is.na(weight_with_na)] <- 0


## Infinity ####

# Create a vector with Inf values
weight_with_inf <- c(91, 75.5, Inf, 88.5, 120, -Inf)

# Extract finite values (non-Infinite)
weight_with_inf[is.finite(weight_with_inf)]

# Check for infinite values
is.infinite(weight_with_inf)

# Check for specifically -Inf values
weight_with_inf == -Inf

## NaN ####

# Create a vector with NaN values
weight_with_nan <- c(91, 75.5, NaN, 88.5, 120)

# Extract non-NaN values
weight_with_nan[!is.nan(weight_with_nan)]

# Check for NaN values
is.nan(weight_with_nan)


