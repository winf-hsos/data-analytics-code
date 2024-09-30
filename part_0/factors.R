# Introduction to factors ####

## Create a factor ####
weight_category <- factor(c("heavy", "medium", "light", "medium", "heavy"))

print(weight_category)

## Check the levels of the factor ####
levels(weight_category)


## Create a factor with specific levels ####
weight_category_ordered <- factor(c("heavy", "medium", "light", "medium", "heavy"),
                                  levels = c("light", "medium", "heavy"))

print(weight_category_ordered)

## Reorder the factor levels ####
weight_category_reordered <- factor(weight_category, levels = c("light", "medium", "heavy"))

print(weight_category_reordered)

## Create an ordered factor (ordinal) ####
ordered_weight_category <- factor(c("light", "medium", "heavy", "light", "heavy"),
                                  levels = c("light", "medium", "heavy"), ordered = TRUE)

# Print the ordered factor
print(ordered_weight_category)

# Check if one factor level is greater than another
ordered_weight_category[1] < ordered_weight_category[2]