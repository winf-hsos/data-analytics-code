# Databricks notebook source
# MAGIC %md
# MAGIC # Load or refresh the data from OWID
# MAGIC The following script is written in Scala. It takes care of the following steps to load the latest version of the Covid19 dataset into Databricks initially:
# MAGIC <br><br>
# MAGIC 
# MAGIC 1. Copy the data over the internet from the OWID GitHub repository and store it in the local Databricks file system.
# MAGIC 2. Create a new Delta Table from the JSON file. Delta Tables are the internal table structure used by Databricks and closely related to Apache Hive tables.
# MAGIC 3. Remove the JSON source file to clean up space.
# MAGIC 
# MAGIC **This script need only be executed once, unless you want to get a new version of the data. Use the script further below to recreate the table when a new cluster has been started, but the data hasn't changed.**

# COMMAND ----------

# MAGIC %scala
# MAGIC import scala.sys.process._
# MAGIC  
# MAGIC // Choose a name for your resulting table in Databricks
# MAGIC var tableName = "owid_covid"
# MAGIC  
# MAGIC // URL to Covid-19 dataset as CSV
# MAGIC var url = "https://covid.ourworldindata.org/data/owid-covid-data.csv"
# MAGIC  
# MAGIC var localpath = "/tmp/" + tableName + ".csv"
# MAGIC dbutils.fs.rm("file:" + localpath)
# MAGIC "wget -O " + localpath + " " + url !!
# MAGIC  
# MAGIC dbutils.fs.mkdirs("dbfs:/datasets")
# MAGIC dbutils.fs.cp("file:" + localpath, "dbfs:/datasets")
# MAGIC  
# MAGIC // Create (overwrite) table
# MAGIC sqlContext.sql("drop table if exists " + tableName)
# MAGIC var df = spark.read.option("header", "true").option("inferSchema", "true").csv("/datasets/" + tableName + ".csv");
# MAGIC df.write.saveAsTable(tableName);
# MAGIC  
# MAGIC // Clean up
# MAGIC dbutils.fs.rm("dbfs:/datasets/" + tableName + ".csv")
# MAGIC  
# MAGIC // Show result summary
# MAGIC var q = "select '" + tableName + "', count(1) from " + tableName
# MAGIC display(sqlContext.sql(q).collect())

# COMMAND ----------

# MAGIC %md
# MAGIC # Re-create the table after cluster restart
# MAGIC When Databricks shuts down our cluster due to 2h inactivity in the community edition, all data in the cluster is gone. However, the data in our local Databricks file system (DBFS) is kept permanently. We can re-create the Delta Table from the DBFS using the following command. That saves us the time to transfer the large file over the internet every time we start a new cluster.

# COMMAND ----------

# MAGIC %sql
# MAGIC -- Create the table from the original location. The pattern of the path is always the same.
# MAGIC -- Will not work if the table is already there
# MAGIC CREATE TABLE owid_covid USING DELTA LOCATION 'dbfs:/user/hive/warehouse/owid_covid/';

# COMMAND ----------

# MAGIC %md
# MAGIC # Load libraries (`sparklyr`, `dplyr`)
# MAGIC In this notebook, we'll use `sparklyr` to access the data and functionality of the Spark cluster. `sparklyr` is an alternative to `SparkR` and provides a interface to the data similar to `dplyr`. In the background, quries with `sparklyr` are translated into Spark SQL queries and then executed.

# COMMAND ----------

library(sparklyr)
library(dplyr)
sc <- spark_connect(method = "databricks")

# COMMAND ----------

# MAGIC %md
# MAGIC # Access data on the Spark Cluster
# MAGIC With `sdf_sql`, we can access a Delta Table on the Spark cluster:

# COMMAND ----------

covid <- sdf_sql(sc, "select * from owid_covid")

# COMMAND ----------

# MAGIC %md
# MAGIC # Use the well-known `dplyr` verbs to transform data
# MAGIC Once we have access to the data in a Spark dataframe (`covid`), we can transform the data using the well-known `dplyr` verbs. Again, in the background the query is translated to SQL.

# COMMAND ----------

covid %>%
  filter(location == "Germany") %>%
  count()

# COMMAND ----------

# MAGIC %md
# MAGIC # Translate and show SQL
# MAGIC We can also ask directly for the SQL statement that runs in the background:

# COMMAND ----------

covid_ger <- covid  %>%
  filter(location == "Germany")

covid_ger %>% 
  show_query()

# COMMAND ----------

# MAGIC %md
# MAGIC # Run SQL from within the notebook

# COMMAND ----------

# MAGIC %md
# MAGIC Thanks to the multi-lingual Apache Spark platform and flexible Databricks notebooks, we can re-run the same query with SQL:

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT *
# MAGIC FROM `sparklyr_tmp_ba1ec0db_0bb7_4e0d_9e77_d3209f80eea0`
# MAGIC WHERE (`location` = "Germany")

# COMMAND ----------

# MAGIC %md
# MAGIC # Visualize data with `ggplot2`
# MAGIC Since the Spark driver is running an R environment, we can use all R packages we usually use to analyze and visualize data. This includes the `tidyverse` with `ggplot2` among others.

# COMMAND ----------

library(ggplot2)

covid_ger %>%
  ggplot() +
  aes(x = date, y = new_cases_smoothed) + 
  geom_line()

# COMMAND ----------

# MAGIC %md 
# MAGIC # Visualize data with built-in functionality
# MAGIC Databricks notebooks come with a built-in function `display()`. The function can either print the result of a query as a table, or we can create a quick visualization from the result data using a drag & drop approach. The visualizations are great for exploratory data analysis where we quickly want to see patterns and don't care about the last detail too much.

# COMMAND ----------

plot_data <- 
  covid_ger %>%
    select(date, new_cases_smoothed) %>%
    filter(!is.na(new_cases_smoothed))

# collect() fetches the data into R as a tibble
tbl_plot_data <- plot_data %>% collect()

# The display function is provided by Databricks environment
display(tbl_plot_data)

# COMMAND ----------

# MAGIC %md
# MAGIC # Get data from Spark into R
# MAGIC As shown above, with the `collect()` function, we can get data from the Spark cluster into the R environment as a Tibble:

# COMMAND ----------

plot_data <- 
  covid_ger %>%
    select(date, new_cases_smoothed) %>%
    filter(!is.na(new_cases_smoothed))

tbl <- plot_data %>% collect()

display(tbl)
