## Script to bulk import all of the air quality data available until now 

# Author: Jean Michel Arreola Trapala
# Date: 22/08/2017
# Contact: jean.arreola@yahoo.com.mx

#Init time

init <- Sys.time()

#Load auxiliary functions
source("aux_functions.R")

years <- 1992:as.numeric(format(Sys.time(), "%Y"))
years <- as.character(years)

#Upload data
all_data <- lapply(years, load_sedema)
all_data <- do.call(rbind, all_data)
update_sedema(all_data)

#End time
cat("Time elapsed:",Sys.time() - init)