library(tidyverse)

# Load the data sets
crime_scene_report <- readRDS("data/murder_mystery/crime_scene_report.rds")
drivers_license <- readRDS("data/murder_mystery/drivers_license.rds")
facebook_event_checkin <- readRDS("data/murder_mystery/facebook_event_checkin.rds")
get_fit_now_check_in <- readRDS("data/murder_mystery/get_fit_now_check_in.rds")
get_fit_now_member <- readRDS("data/murder_mystery/get_fit_now_member.rds")
income <- readRDS("data/murder_mystery/income.rds")
interview <- readRDS("data/murder_mystery/interview.rds")
person <- readRDS("data/murder_mystery/person.rds")

crime_scene_report |> 
  glimpse()

# Get started...
crime_scene_report |> 
  filter(date == "20180115") |> 
  filter(city == "SQL City") |> 
  filter(type == "murder") |> 
  select(description) |> 
  pull()

# Security footage shows that there were 2 witnesses. 
# The first witness lives at the last house on "Northwestern Dr". 
# The second witness, named Annabel, lives somewhere on "Franklin Ave"

person |> 
  glimpse()

