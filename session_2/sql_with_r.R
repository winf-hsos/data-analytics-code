#install.packages("sqldf")
library(sqldf)

# Load the data from RDS
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Remove complex column types
tweets_sql <- tweets %>% 
  select(-urls, -hashtags, -photos, -user_mentions)

glimpse(tweets_sql)

result <- sqldf("
                select screen_name, 
                       count(1) as num_tweets 
                from tweets_sql 
                where screen_name like '%Baer%' 
                group by screen_name
                ")

# Make a tibble
result_tbl <- as_tibble(result)
result_tbl