#install.packages("tidytext")
library(tidytext)

tweets |> 
  tidytext::unnest_tokens(word, text, token = "words", drop = F) |> 
  count(word, sort = T)
