#### Load data from CSV ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# Read CSV files with delimiters and decimal points ####

# The function read_csv() uses comma as the delimiter and "." as decimal point
orders <- read_csv("data/campusbier/orders.csv")

# Get the columns names and data types
orders |> 
  glimpse()

# The function read_csv2() uses semicolon and "," as decimal point
body_measures <- read_csv2("data/body_measures.csv")

body_measures |> 
  glimpse()

# While we're at it, let's convert the timestamp column
body_measures |>
  janitor::clean_names() |> 
  mutate(timestamp = lubridate::dmy_hms(timestamp))


# If you need full control over the delimiter and decimal point
body_measures <- read_delim("data/body_measures.csv", 
                            delim = ";",
                            locale = locale(decimal_mark = ","))

body_measures |> 
  glimpse()


# Select specific columns at load time ####

# Select only specific columns when loading the data
# This can also be achieved with SELECT later on

# We can directly list the columns we want to load
orders <- read_csv("data/campusbier/orders.csv",
                   col_select = c(order_id, total_price))

# Or we can use all the helpers available, e.g. via name pattern
orders <- read_csv("data/campusbier/orders.csv",
                   col_select = c(order_id, name, starts_with("customer")))

# When we only have on criteria, the c() function is not needed
orders <- read_csv("data/campusbier/orders.csv", 
                   col_select = starts_with("shipping"))


# Change the data type of columns at load time ####

orders <- read_csv("data/campusbier/orders.csv",
                   col_types = list("order_id" = col_character()))

# The column order_id is now "chr"
orders |> 
  select(order_id)

# Setting data type for multiple columns
orders <- read_csv("data/campusbier/orders.csv",
                   col_types = list(
                     "order_id" = col_character(),
                     "app_id" = col_character(),
                     "billing_address_zip"= col_character(),
                     "shipping_address_zip"= col_character()
                   )
)

orders |> 
  select(order_id, app_id, billing_address_zip, shipping_address_zip)

# Loading a CSV file from a web server
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")
