# This script contains all code we wrote and discussed in session 1

tweets %>% 
  select(screen_name) %>% 
  tail(10)

tweets %>% 
  select(screen_name, text)

tweets %>% 
  select(-screen_name, -id)

tweets %>% 
  select(ends_with("count"))

tweets %>% 
  select(where(is.numeric))

