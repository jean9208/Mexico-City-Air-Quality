## Script to create the data quality table on a PostgreSQL instance ##

# Author: Jean Michel Arreola Trapala
# Date: 22/08/2017
# Contact: jean.arreola@yahoo.com.mx


# Load PostgreSQL client

library(RPostgreSQL)


# SQL query to create main table if it not exists

"
CREATE TABLE IF NOT EXISTS air_quality (
  FECHA date,  
  HORA integer,
  NO_OZONO integer,
  NO_AZUFRE integer,
  NO_NITROGENO integer,
  NO_CARBONO integer,
  NO_PM10 integer,
  NE_OZONO integer,
  NE_AZUFRE integer,
  NE_NITROGENO integer,
  NE_CARBONO integer,
  NE_PM10 integer,
  CE_OZONO integer,
  CE_AZUFRE integer,
  CE_NITROGENO integer,
  CE_CARBONO integer,
  CE_PM10 integer,
  SO_OZONO integer,
  SO_AZUFRE integer,
  SO_NITROGENO integer,
  SO_CARBONO integer,
  SO_PM10 integer,
  SU_OZONO integer,
  SU_AZUFRE integer,
  SU_NITROGENO integer,
  SU_CARBONO integer,
  SU_PM10 integer,
  ID serial,
  PRIMARY KEY (ID)
)
" -> query


# Load credentials

source("credentials.R")


# Connect to database

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, dbname = user, 
                 host = db_url, port = 5432,
                 user = user, password = pwd)


# Create table

dbGetQuery(con, query)


# Close the connection

dbDisconnect(con)

#dbUnloadDriver(drv)

