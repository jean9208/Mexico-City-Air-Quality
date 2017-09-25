## Auxiliary functions ##

# Author: Jean Michel Arreola Trapala
# Date: 22/08/2017
# Contact: jean.arreola@yahoo.com.mx


#Libraries
library(RPostgreSQL)


#Download data from SEDEMA and remove unnecessary columns/rows.

load_sedema <- function(year){

  #URL to the file
  #from 1992
  link <- paste0("http://148.243.232.112:8080/opendata/IndiceCalidadAire/indice_",year,".csv") 
  
  #Columns classes
  types <- c("character", rep("numeric",26))
  
  
  #Download the file
  air_data <- read.csv(link,skip = 9, stringsAsFactors = F, encoding = "latin1", header = F,
                       colClasses = types, na.string = "NA")
  
  
  #Remove missing data
  air_data <- air_data[!air_data[,1]=="",1:27]
  
  #Fix time variable
  air_data$V1 <- paste0(substring(air_data$V1, 1, 6), year) #We need to asure that all dates are from the specified year
  
  return(air_data)

}


#Function to upload data to Postgresql

update_sedema <- function(data){
  #Save the last date to update from that point onwards
  #last <- max(data$V1)

  #SQL query to get the last date available in the table
  
  query <- 
  "
  SELECT 
    max(FECHA) FECHA,
    max(ID) ID
  FROM
    air_quality
  
  "
  
  
  # Load credentials
  
  source("credentials.R")
  
  
  # Connect to database
  
  drv <- dbDriver("PostgreSQL")
  
  con <- dbConnect(drv, dbname = user, 
                   host = db_url, port = 5432,
                   user = user, password = pwd)
  
  
  # Execute query
  
  last <- dbGetQuery(con, query)
  
  data$V1 <- strptime(data$V1, "%d/%m/%Y")  
  
  #Set indicator for ID
  
  if(is.na(last$fecha)==F){
    data <- data[as.Date(data$V1) > last$fecha,]
    ind <- last$id + 1
  } else 
      ind <- 1
  
  if(nrow(data) == 0)
    return()
  
  #Set ID and a better format for date
  
  data$id <- seq(ind,nrow(data) + ind - 1)
  data$V1 <- gsub("/","-",data$V1)
  
  #Upload data
  
  dbWriteTable(conn = con, name = "air_quality",value = data, append = T, row.names = F)
    
  
  # Close the connection
  
  on.exit(dbDisconnect(con))
  
  #dbUnloadDriver(drv)
  
  cat("Succesfully uploaded")
  
  rm(data)
  
  return(NULL)
  
}


