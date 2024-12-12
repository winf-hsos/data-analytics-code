# Introduction to factors ####

library(tidyverse)

## Create a factor ####
# Create a vector
weight_vector <- c("heavy", "medium", "light", "medium", "heavy", "heavy", "medium", "heavy")

# Convert to factor
weight_category <- factor(weight_vector)
weight_category

# Using as_factor from Tidyverse to preserve from data
weight_category <- as_factor(weight_vector)
weight_category

## Check the levels of the factor ####
levels(weight_category)

## Create a factor with specific levels ####
weight_category_ordered <- factor(c("heavy", "medium", "light", "medium", "heavy"),
                                  levels = c("light", "medium", "heavy", "super-heavy"))

levels(weight_category_ordered)

## Reorder the factor levels manually ####
weight_category_reordered <- 
  factor(weight_category, levels = c("light", "medium", "heavy"))

print(weight_category_reordered)

## Create an ordered factor (ordinal) ####
ordered_weight_category <- factor(c("light", "medium", "heavy", "light", "heavy"),
                                  levels = c("light", "medium", "heavy"), ordered = TRUE)

# Print the ordered factor
print(ordered_weight_category)

# Check if one factor level is greater than another
ordered_weight_category[1] < ordered_weight_category[2]

# Forcats
fct_lump(weight_category)
fct_infreq(weight_category)
fct_relevel(weight_category, "light", "medium")
fct_rev(weight_category)
fct_collapse(weight_category, light = c("light", "medium"))
