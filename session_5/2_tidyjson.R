library(tidyjson)

# With tidyjson, we can read JSON files directly as tbl_json objects
tweets <- read_json("./data/tweets_ampel.json.gz", format="jsonl")

# Take a look at the tidyjson documentation for more details:
# https://cran.r-project.org/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html