library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "data/tweets_ampel.rds")

# Check if it worked
glimpse(tweets)

# Select columns by name
tweets |> 
  select(screen_name, text)

# Select columns that start with a prefix
tweets |> 
  select(starts_with("s"))

# Select columns that end in a prefix
tweets |> 
  select(ends_with("_count"))

# Select columns that contain a specific string
tweets |> 
  select(contains("screen"))

# Select columns that are matched by a regular expression (here no result)
tweets |> 
  select(matches("\\s"))

# Select columns by their data type
tweets |> 
  select(where(is.numeric))

tweets |> 
  select(where(is.logical))

tweets |> 
  select(where(is.character))

tweets |> 
  select(where(is.factor))

tweets |> 
  select(where(is.list))

# The package lubridate provides a function to check for date (without time)
library(lubridate)
tweets |> 
  select(where(lubridate::is.Date))

tweets |> 
  select(where(lubridate::is.POSIXct))

# We can also write a custom function to identify dates as well 
# as datetime columns
is.DateTime <- function(x) {
  inherits(x, c("Date", "POSIXct"))
}

tweets |> 
  select(where(is.DateTime))

# Exclude columns from selection
tweets |> 
  select(-text)

# All columns that end in count, but exclude two of them
tweets |> 
  select(ends_with("_count"), -quote_count, -reply_count)

# Select last column
tweets |> 
  select(last_col())

# Select last second last column 
tweets |> 
  select(last_col(2))

# Select first column
tweets |> 
  select(1)

# Select a range of columns
tweets |> 
  select(2:6)

# Select everything but the last two columns
tweets |> 
  select(1:last_col(2))

# Define a set of columns in a vector and select this set
cols <- c("screen_name", "text", "retweet_count")

tweets |> 
  select(all_of(cols))

# Read more...
# https://r4ds.hadley.nz/data-transform.html#sec-select
# Sauer 2019: Kapitel 7.2.3 ab S. 81
# https://dplyr.tidyverse.org/reference/select.html
# https://wordlens.datalit.de/part-1-exploring-data/data-transformation/select-columns
