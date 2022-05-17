# This script contains examples for the theme layer in ggplot2

library(tidyverse)
library(cowplot)

# Load windows fonts (for later use)
install.packages("showtext")
library(showtext)
showtext_auto()

# Load a font from Google Fonts
font_add_google("Special Elite", family = "special")

# Get the latest data from OWID
covid <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

# Load the tweets
tweets <- readRDS(file = "./data/tweets_ampel.rds")

# Load REWE data
rewe <- read_csv("./data/rewe_products.csv")

# Load the Limonade survey data
limonade <- read_csv("./data/limonade.csv")

colnames(limonade)

# apply a predefined theme
limonade %>%
  transmute(alter = 2021 - f39_geburtsjahr, studiengang = as.factor(f44_studiengang)) %>%
  filter(alter < 100 & studiengang != "-999") %>%
  
  ggplot(aes(x = alter, y = ..density..)) +
  geom_histogram(binwidth = 1, alpha = 0.8) +
  facet_wrap(~studiengang, ncol = 2) +
  ggtitle("Age Distribution by Study Program") +
  labs(y = "Proportion", x = "Age") +
  theme_cowplot()

# Adjust a theme's font
limonade %>%
  transmute(alter = 2021 - f39_geburtsjahr, studiengang = as.factor(f44_studiengang)) %>%
  filter(alter < 100 & studiengang != "-999") %>%
  
  ggplot(aes(x = alter, y = ..density..), family = "special") +
  geom_histogram(binwidth = 1, color="#000000", fill="#009ee3", alpha = 0.8) +
  facet_wrap(~studiengang, ncol = 2) +
  ggtitle("Age Distribution by Study Program") +
  labs(y = "Proportion", x = "Age") +
  theme_cowplot() +
  theme(title = element_text(color = "#009ee3", family = "special", size = 28),
        axis.title.x = element_text(color = "black", size = 18),
        axis.title.y = element_text(color = "black", size = 18),
        )
