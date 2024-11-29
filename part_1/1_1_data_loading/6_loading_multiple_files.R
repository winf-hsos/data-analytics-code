library(tidyverse)

# List all files with a specific pattern in its name
metadata_files <- dir("data/youtube/", pattern = "\\videos.csv$", full.names = TRUE)

# Load all files from the previous step using the map function with list_rbind (row bind)
yt_metadata <- metadata_files |> 
  map(read_csv) |> 
  list_rbind()

yt_metadata |> 
  count(channel_title, sort = TRUE)