library(tidyverse)

# Load the form data from the survey
form_data <- readRDS(file = "./data/gaming_study/formr.rds")

# Load the telemetry data
tele <- read_tsv("./data/gaming_study/telem_data.txt")

# 1. Make yourself familiar with the survey and Nintendo telemetry data!

# 2. Perform some data quality checks. Have a look at the official website
# from the authors to get ideas!

# 3. Read the paper and the chapter 3 from the online documentation! Try to
# follow the exploratory analysis the authors performed (chapter 4). 
# What else do you find interesting to look at?


# Link to author's website: https://digital-wellbeing.github.io/gametime/
# Link to paper: https://psyarxiv.com/qrjza/

# Chapter 3.2.2 show steps for processing telemetry data: 
# https://digital-wellbeing.github.io/gametime/process-acnh-data.html