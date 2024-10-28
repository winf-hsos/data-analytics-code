# Pipes are a very useful concept and are introduced by the magittr package
# The package is included in the tidyverse.

# WE ALWAYS USE PIPES! 👍

# Without a pipe (the hard way!) 😒
head(
  arrange(
    select(
      filter(
        mutate(
            filter(tweets, !is_retweet),
            is_top_tweet = retweet_count >= quantile(retweet_count, 0.99)
        )
        ,is_top_tweet
      ),
      retweet_count, screen_name, text
    ),
    -retweet_count
  ),
  5
)

# With intermediate steps - better to read, but cumbersome to change 🤦
no_rts <- filter(tweets, !is_retweet)
with_top_tweets <- mutate(no_rts, is_top_tweet = retweet_count >= quantile(retweet_count, 0.99))
only_top_tweets <- filter(with_top_tweets, is_top_tweet)
relevant_cols <- select(only_top_tweets, retweet_count, screen_name, text)
sorted <- arrange(relevant_cols, -retweet_count)
head(sorted, 5)


# With pipes :-) Easy to read and understand. Simple to change 😊
tweets |>
  filter(!is_retweet) |> 
  mutate(is_top_tweet = retweet_count >= quantile(retweet_count, 0.99)) |> 
  filter(is_top_tweet) |>
  select(retweet_count, screen_name, text) |> 
  arrange(-retweet_count) |> 
  head(5)

# Read more...
# https://r4ds.hadley.nz/data-transform.html#sec-the-pipe
