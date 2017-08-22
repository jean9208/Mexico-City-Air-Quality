## Auxiliary functions ##

# Author: Jean Michel Arreola Trapala
# Date: 22/08/2017
# Contact: jean.arreola@yahoo.com.mx


#Download data from SEDEMA and remove some unnecessary columns/rows.

load_sedema <- function(year){

  #URL to the file
  #from 1992
  link <- paste0("http://148.243.232.112:8080/opendata/IndiceCalidadAire/indice_",year,".csv") 
  
  #Columns classes
  types <- c("character", rep("numeric",26), rep("NULL",2))
  
  
  #Download the file
  air_data <- read.csv(link,skip = 9, stringsAsFactors = F, encoding = "latin1", header = F,
                       colClasses = types, na.string = "NA")
  
  
  #Remove missing data
  air_data <- air_data[!air_data[,1]=="",]
  
  return(air_data)

}






