# Joinig data sets
library(tidyverse)
library(readxl)
library(janitor)

tweets <- readRDS("data/tweets_ampel.rds")

# Load the meta data from Excel
meta <- 
  read_excel("data/tweets_metadata.xlsx") |> 
  clean_names() # make column names nicer

meta |> 
  colnames()

# 1. Inner Join ####

tweets |> 
  distinct(screen_name)

# One screen name is missing in meta data
tweets |> 
  inner_join(meta, by = join_by(screen_name == user_screenname)) |> 
  distinct(screen_name)

# keep = TRUE to keep both join keys in the data set
tweets |> 
  inner_join(meta, by = join_by(screen_name == user_screenname), keep = TRUE) |>
  distinct(screen_name, user_screenname, party)

# 2. Left Join

# Keep all tweets, regardless of whether we have metadata for the user
tweets |> 
  left_join(meta, by = join_by(screen_name == user_screenname)) |> 
  distinct(screen_name, party)

# 3. Right Join

# Keep all users from the meta data set, even if there are no tweets
tweets |> 
  right_join(meta, by = join_by(screen_name == user_screenname)) |> 
  distinct(screen_name, party)

# 4. Full Join

# Keep all rows from both data sets
tweets |> 
  full_join(meta, by = join_by(screen_name == user_screenname)) |> 
  distinct(screen_name, party)


# 5. Dummy example orders and customers ####

orders <- tibble(order_id = c(1, 2, 3, 4, 5), customer_id = c(1, 2, 3, 1, NA))
customers <- tibble(customer_id = c(1, 2, 3, 4), last_name = c("Müller", "Meyer", "Schulze", "Schmidt"))

orders |> 
  inner_join(customers)

# order_id customer_id last_name
#<dbl>       <dbl> <chr>    
# 1        1           1 Müller   
# 2        2           2 Meyer    
# 3        3           3 Schulze  
# 4        4           1 Müller 


orders |> 
  left_join(customers)

# order_id customer_id last_name
# <dbl>       <dbl> <chr>    
# 1        1           1 Müller   
# 2        2           2 Meyer    
# 3        3           3 Schulze  
# 4        4           1 Müller   
# 5        5          NA <NA>    

orders |> 
  right_join(customers)

# order_id customer_id last_name
# <dbl>       <dbl> <chr>    
# 1        1           1 Müller   
# 2        2           2 Meyer    
# 3        3           3 Schulze  
# 4        4           1 Müller   
# 5       NA           4 Schmidt 

orders |> 
  full_join(customers)

# order_id customer_id last_name
# <dbl>       <dbl> <chr>    
# 1        1           1 Müller   
# 2        2           2 Meyer    
# 3        3           3 Schulze  
# 4        4           1 Müller   
# 5        5          NA <NA>     
# 6       NA           4 Schmidt  

orders |>
  cross_join(customers)

# order_id customer_id.x customer_id.y last_name
# <dbl>         <dbl>         <dbl> <chr>    
# 1        1             1             1 Müller   
# 2        1             1             2 Meyer    
# 3        1             1             3 Schulze  
# 4        1             1             4 Schmidt  
# 5        2             2             1 Müller   
# 6        2             2             2 Meyer    
# 7        2             2             3 Schulze  
# 8        2             2             4 Schmidt  
# 9        3             3             1 Müller   
# 10        3             3             2 Meyer    
# 11        3             3             3 Schulze  
# 12        3             3             4 Schmidt  
# 13        4             1             1 Müller   
# 14        4             1             2 Meyer    
# 15        4             1             3 Schulze  
# 16        4             1             4 Schmidt  
# 17        5            NA             1 Müller   
# 18        5            NA             2 Meyer    
# 19        5            NA             3 Schulze  
# 20        5            NA             4 Schmidt  



