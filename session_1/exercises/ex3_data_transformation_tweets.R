library(tidyverse)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# 1. Create a data frame with the months of 2022 in one column and the average number of retweets in another! Group the data by screen name!

# 2. Who uses the most hashtags on average?

# 3. What is the average length of a tweet in the data set? (Hint: the function nchar() returns the length of a string)

# 4. Who writes the longest tweets? Consider only original tweets!

# 5. Who tweeted the most in March 2022?

# 6. What hour of the day is the most active regarding the number of tweets?

# 7. What time does Annalena Baerbock go to bed? When does she wake up?

# 8. Which account do each of the ministers retweet most often? (Hint: check slice_max() for help)