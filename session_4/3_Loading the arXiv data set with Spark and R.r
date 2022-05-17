# Databricks notebook source
# MAGIC %md
# MAGIC # About the data
# MAGIC The arXiv data set [is provided on Kaggle.com](https://www.kaggle.com/datasets/Cornell-University/arxiv) and contains meta data about all papers published on the <a href="https://arxiv.org/" target="_blank">arXiv-platform</a>.

# COMMAND ----------

# MAGIC %md
# MAGIC # Initial loading of the data set
# MAGIC The following script is written in Scala. It takes care of the following steps to load the arXiv dataset into Databricks initially:
# MAGIC <br><br>
# MAGIC 
# MAGIC 1. Copy the data over the internet from an Amazon S3 repository and store it in the local Databricks file system.
# MAGIC 2. Create a new Delta Table from the JSON file. Delta Tables are the internal table structure used by Databricks.
# MAGIC 3. Remove the JSON source file to clean up space.
# MAGIC 
# MAGIC **This script need only be executed once, unless the data in the S3 source changes. Use the script further below to recreate the table when a new cluster has been started**

# COMMAND ----------

# MAGIC %scala
# MAGIC import scala.sys.process._
# MAGIC import org.apache.spark.sql.functions._
# MAGIC import org.apache.spark.sql.types.{TimestampType}
# MAGIC 
# MAGIC spark.conf.set("spark.sql.legacy.timeParserPolicy","LEGACY")
# MAGIC 
# MAGIC var tables = Array("arxiv_metadata")
# MAGIC 
# MAGIC val file_ending = ".json.gz"
# MAGIC 
# MAGIC for(t <- tables) {
# MAGIC 
# MAGIC   val tableName = t
# MAGIC   val sourceFileName = "2022-05-17-arxiv-metadata-oai-snapshot.json.gz"
# MAGIC   
# MAGIC   dbutils.fs.rm("file:/tmp/" + sourceFileName)
# MAGIC 
# MAGIC   "wget -P /tmp https://s3.amazonaws.com/nicolas.meseth/data-sets/" + sourceFileName !!
# MAGIC 
# MAGIC   val localpath = "file:/tmp/" + sourceFileName
# MAGIC   dbutils.fs.rm("dbfs:/datasets/" + sourceFileName)
# MAGIC   dbutils.fs.mkdirs("dbfs:/datasets/")
# MAGIC   dbutils.fs.cp(localpath, "dbfs:/datasets/")
# MAGIC   display(dbutils.fs.ls("dbfs:/datasets/" +  sourceFileName))
# MAGIC 
# MAGIC   sqlContext.sql("drop table if exists " + tableName)
# MAGIC   
# MAGIC   var df = spark.read.option("inferSchema", "true").json("/datasets/" +  sourceFileName)
# MAGIC  
# MAGIC   // Create a table
# MAGIC   df.write.saveAsTable(tableName);
# MAGIC   
# MAGIC   // Clean up
# MAGIC   dbutils.fs.rm("dbfs:/datasets/" + sourceFileName)
# MAGIC   dbutils.fs.rm("file:/tmp/" + sourceFileName)
# MAGIC }

# COMMAND ----------

# MAGIC %md
# MAGIC # Re-create the table after cluster restart
# MAGIC When Databricks shuts down our cluster due to 2h inactivity in the community edition, all data in the cluster is gone. However, the data in our local Databricks file system (DBFS) is kept permanently. We can re-create the Delta Table from the DBFS using the following command. That saves us the time to transfer the large file over the internet every time we start a new cluster.

# COMMAND ----------

# MAGIC %sql
# MAGIC -- Create the table from the original location. The pattern of the path is always the same
# MAGIC -- Will not work if the table is already there
# MAGIC CREATE TABLE arxiv_metadata USING DELTA LOCATION 'dbfs:/user/hive/warehouse/arxiv_metadata/';

# COMMAND ----------

# MAGIC %md
# MAGIC # Using SQL to explore the data
# MAGIC  A nice feature of Apache Spark is that it supports so many languages. We can use SQL to access the data in a Spark SQL table (Delta Table). Let's start with that before we dive into R.
# MAGIC  
# MAGIC  Within a notebook, we can temporarily switch the language using the `%` sign followed by the languages name. `%sql` tells the code block to interpret the commands as SQL.

# COMMAND ----------

# MAGIC %md
# MAGIC ## Get the column metadata
# MAGIC The SQL command `describe` gives us the column meta data for a given table:

# COMMAND ----------

# MAGIC %sql
# MAGIC describe arxiv_metadata

# COMMAND ----------

# MAGIC %md
# MAGIC # Transformations with SQL

# COMMAND ----------

# MAGIC %md
# MAGIC When we look at the values in the `versions` column, there seem to be date values stored as strings.

# COMMAND ----------

# MAGIC %sql
# MAGIC select
# MAGIC   versions
# MAGIC from
# MAGIC   arxiv_metadata
# MAGIC limit
# MAGIC   10

# COMMAND ----------

# MAGIC %md
# MAGIC We can access the first version by addressing the first entry in the array. Additionally, we are only interested in the field `created` from the stored JSON object:

# COMMAND ----------

# MAGIC %sql
# MAGIC select
# MAGIC   versions[0].created
# MAGIC from
# MAGIC   arxiv_metadata
# MAGIC limit
# MAGIC   10

# COMMAND ----------

# MAGIC %md
# MAGIC With SQL (as well as with Scala, R or Python for that matter), we can transform the string into a date so we can use it for analysis:

# COMMAND ----------

# MAGIC %sql
# MAGIC set spark.sql.legacy.timeParserPolicy=LEGACY

# COMMAND ----------

# MAGIC %sql
# MAGIC select cast(
# MAGIC     unix_timestamp(versions[0].created, "EEE, d MMM yyyy HH:mm:ss zzz") as timestamp
# MAGIC   ) as version_timestamp
# MAGIC from arxiv_metadata

# COMMAND ----------

# MAGIC %md
# MAGIC ## Create a view for the transformation
# MAGIC Let's wrap this transformation in a view on the data, so we don't have to repeat the cumbersome piece of date transformation code:

# COMMAND ----------

# MAGIC %sql 
# MAGIC create or replace temporary view v_arxiv as  
# MAGIC select
# MAGIC   *,
# MAGIC   cast(
# MAGIC     unix_timestamp(
# MAGIC       versions [0].created,
# MAGIC       "EEE, d MMM yyyy HH:mm:ss zzz"
# MAGIC     ) as timestamp
# MAGIC   ) as version_timestamp
# MAGIC from
# MAGIC   arxiv_metadata

# COMMAND ----------

# MAGIC %sql
# MAGIC select
# MAGIC   title,
# MAGIC   version_timestamp
# MAGIC from
# MAGIC   v_arxiv
# MAGIC limit
# MAGIC   10

# COMMAND ----------

# MAGIC %md
# MAGIC ## Create a table from a view for better performance
# MAGIC 
# MAGIC At query time, a view re-calculates all expressions and transformations it contains. This makes views a bit slower than querying a persistent table. We can easily create a table from a view using one of the languages. The example below illustrates how to do it in Pyhton. We first create a data frame from a query on the view and then create a new Delta Table from that view. Next time we load the data, we can load it from the location of the table `arxiv_prep` and we save the time for date conversion.
# MAGIC 
# MAGIC **Creating a new table with comparatively large amounts of data may take a minute or two! But it pays off if you perform extensive analysis afterwards.**

# COMMAND ----------

# MAGIC %python 
# MAGIC # Query the view and create a data frame from it
# MAGIC df = spark.sql("select * from v_arxiv");
# MAGIC 
# MAGIC # Tabelle löschen, falls bereits vorhanden
# MAGIC spark.sql("drop table if exists arxiv_prep")
# MAGIC 
# MAGIC # Persistente Tabelle erstellen
# MAGIC df.write.saveAsTable("arxiv_prep")

# COMMAND ----------

# MAGIC %md
# MAGIC If you get an error that the location exists in Hive *bla bla bla*, run the following command to clean up:

# COMMAND ----------

# MAGIC %python
# MAGIC dbutils.fs.rm("dbfs:/user/hive/warehouse/arxiv_prep", True)

# COMMAND ----------

# MAGIC %md
# MAGIC Or if you haven't loaded a new version of the data, restore the table from the Hive catalog:

# COMMAND ----------

# MAGIC %sql
# MAGIC -- Create the table from the original location. The pattern of the path is always the same
# MAGIC -- Will not work if the table is already there
# MAGIC CREATE TABLE arxiv_prep USING DELTA LOCATION 'dbfs:/user/hive/warehouse/arxiv_prep/';

# COMMAND ----------

# MAGIC %md
# MAGIC Now we can use the new table in an SQL query:

# COMMAND ----------

# MAGIC %sql
# MAGIC select
# MAGIC   year(version_timestamp) as `Year`,
# MAGIC   count(1) as `Number Papers`
# MAGIC from
# MAGIC   arxiv_prep
# MAGIC group by year
# MAGIC order by year

# COMMAND ----------

# MAGIC %md
# MAGIC # Using R to analyse and visualize the data
# MAGIC So now that the data is on our Spark cluster, let's explore how we can access it from this notebook using R.

# COMMAND ----------

library(sparklyr)
library(dplyr)
sc <- spark_connect(method = "databricks")

# COMMAND ----------

arxiv_df <- sdf_sql(sc, "select * from arxiv_prep")

# COMMAND ----------

# MAGIC %md
# MAGIC We can use the well-known `dplyr` verbs to transform our data:

# COMMAND ----------

arxiv_df %>%
  select(title, version_timestamp) %>%
  filter(year(version_timestamp) == 2022)

# COMMAND ----------

# MAGIC %md
# MAGIC And we can show the SQL that is run in the background by `sparklyr`:

# COMMAND ----------

arxiv_df %>%
  select(title, version_timestamp) %>%
  filter(year(version_timestamp) == 2022) %>%
  show_query()

# COMMAND ----------

# MAGIC %md
# MAGIC # Using Python with `PySpark`

# COMMAND ----------

# MAGIC %python
# MAGIC print("We can use Python from our notebook, too :-)")

# COMMAND ----------

# MAGIC %md
# MAGIC Using the Spark interface `PySpark`, we can issue SQL commands from Python and create a data frame from it:

# COMMAND ----------

# MAGIC %python
# MAGIC arxiv = spark.sql("select title from arxiv limit 10")
# MAGIC 
# MAGIC # A regular Spark dataframe
# MAGIC print(arxiv)

# COMMAND ----------

# MAGIC %md
# MAGIC We can easily convert the Spark dataframe to a Pandas dataframe (a popular library in data analysis with Python). This is useful if we want to use popular ML-libraries from within our notebook, such as spaCy, TensorFlow or others.

# COMMAND ----------

# MAGIC %python
# MAGIC # Convert to Pandas dataframe
# MAGIC arxiv_pd = arxiv.toPandas()

# COMMAND ----------

# MAGIC %md
# MAGIC Pandas dataframes are supported by the Databricks `display()` function for prettier printing and quick visualization:

# COMMAND ----------

# MAGIC %python
# MAGIC # Pandas dataframes are supported by the display() function in Databricks
# MAGIC display(arxiv_pd)
