# Databricks notebook source
# MAGIC %md
# MAGIC # Plain R, no Spark!
# MAGIC In this notebook we'll explore how we can use plain R (no Spark yet) in a Databricks notebook. For that, we'll load a familiar dataset from our previous sessions. This time, we load it from the URL of the GitHub repository:

# COMMAND ----------

library(tidyverse)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Get data from a URL

# COMMAND ----------

# Load the tweets dataset from RDS
tweets <- readRDS(url("https://github.com/winf-hsos/big-data-analytics-code/raw/main/data/tweets_ampel.rds"))

# COMMAND ----------

# This prints the tibble, as usual
tweets

# COMMAND ----------

# MAGIC %md
# MAGIC ## The `display()` function

# COMMAND ----------

# MAGIC %md
# MAGIC In Databricks notebooks, we can use the `display()` function to create a prettier table or visualization from the result:

# COMMAND ----------

library(lubridate)

tweets %>%
  filter(year(created_at) == 2022) %>%
  select(screen_name) %>%
  count(screen_name) %>%
  arrange(-n) %>%
  display()

# COMMAND ----------

# MAGIC %md
# MAGIC ## `ggplot2` works, too
# MAGIC Or with we can use `ggplot2` to visualize the data:

# COMMAND ----------

tweets %>%
  filter(year(created_at) == 2022) %>%
  select(screen_name) %>%
  count(screen_name) %>%
  arrange(-n) %>%
  ggplot() +
  aes(x = fct_reorder(screen_name, n), y = n) +
  geom_col(fill = "#009ee3") +
  coord_flip() +
  theme_minimal() +
  labs(x = "User", y = "Number of Tweets")
  

# COMMAND ----------

# MAGIC %md
# MAGIC # Upload to Spark
# MAGIC Although not necessary for such a small data set, we can upload the data to the Spark cluster. For that, we first need to load the `sparklyr` package, with provides an interface to Apache Spark in R:

# COMMAND ----------

# MAGIC %md
# MAGIC ## Connect to the Spark cluster

# COMMAND ----------

# First, we need the sparklyr package
library(sparklyr)

# Connect to the Spark cluster
sc <- spark_connect(method = "databricks")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Copy the data to Spark
# MAGIC Now that we are connected, we can upload (or copy) the data to Spark:

# COMMAND ----------

tweets_tbl <- copy_to(sc, tweets, "tweets")

# COMMAND ----------

# MAGIC %md
# MAGIC The result is no longer a classic tibble, but a wrapped tibble by `sparklyr` that can interact with Apache Spark.

# COMMAND ----------

tweets_tbl

# COMMAND ----------

# MAGIC %md
# MAGIC ## Run distributed transformations
# MAGIC We can keep using `dplyr` verbs with the new wrapped tibble, but now they are executed on the Spark cluster in a distributed fashion:

# COMMAND ----------

tweets_tbl %>%
  filter(screen_name == "ABaerbock")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Get data back from Spark
# MAGIC To get the data back to plain R, we can use the `collect()` function:

# COMMAND ----------

tweets_ab <- tweets_tbl %>%
  filter(screen_name == "ABaerbock") %>%
  collect()

# This is a plain old tibble again in plain R
tweets_ab

# COMMAND ----------

# MAGIC %md
# MAGIC ## With Spark, the fun begings
# MAGIC But let's roll back! With the data on the Spark cluster, the whole set of APIs is available to us. Including Spark SQL!

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from tweets
