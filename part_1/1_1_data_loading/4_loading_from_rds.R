tweets <- readRDS("data/tweets_ampel.rds")

# Removing potential duplicates
tweets |> 
  count()

tweets <- tweets %>%
  distinct(id, .keep_all = TRUE)

tweets |> 
  count()
