library(rgl)
library(plotly)

#Enlaces a los archivos

link <- "http://148.243.232.112:8080/opendata/IndiceCalidadAire/indice_2017.csv"
est  <- "http://148.243.232.112:8080/opendata/catalogos/cat_estacion.csv"
par  <- "http://148.243.232.112:8080/opendata/catalogos/cat_parametros.csv"
uni  <- "http://148.243.232.112:8080/opendata/catalogos/cat_unidades.csv"

#Carga de la informacion

data         <- read.csv(link,skip = 9, stringsAsFactors = F, encoding = "latin1", header = F)
cat_estacion <- read.csv(est, skip=1,stringsAsFactors = F, encoding = "latin1", header= T)
parametros   <- read.csv(par, stringsAsFactors = F, encoding = "latin1")
unidades     <- read.csv(uni, stringsAsFactors = F, encoding = "latin1")

data_names <- c("Fecha","Hora", "Noroeste Ozono",	"Noroeste dióxido de azufre",	
                "Noroeste dióxido de nitrógeno",	"Noroeste monóxido de carbono",	
                "Noroeste PM10",	"Noreste Ozono",	"Noreste dióxido de azufre",	
                "Noreste dióxido de nitrógeno",	"Noreste monóxido de carbono",	
                "Noreste PM10",	"Centro Ozono",	"Centro dióxido de azufre",	
                "Centro dióxido de nitrógeno",	"Centro monóxido de carbono",	
                "Centro PM10",	"Suroeste Ozono",	"Suroeste dióxido de azufre",	
                "Suroeste dióxido de nitrógeno",	"Suroeste monóxido de carbono",	
                "Suroeste PM10",	"Sureste Ozono",	"Sureste dióxido de azufre",	
                "Sureste dióxido de nitrógeno",	"Sureste monóxido de carbono",	
                "Sureste PM10")

colnames(data) <- data_names

data<-data[data$Fecha!="",seq(1,ncol(data)-2)]
data[is.na(data)==T] <- 0

pc <- princomp(data[,3:ncol(data)], cor=TRUE, scores=TRUE)
km <- kmeans(data[,3:ncol(data)],3)
data$cluster <- as.factor(km$cluster)

plot3d(pc$scores[,1:3], col=data$cluster, main="k-means clusters")

apply(data[,3:ncol(data)],c(1,2), function(x){
  if(x<=50) return("BUENA")
  if(51<=x&x<=100) return("REGULAR")
  if(101<=x&x<=150) return("MALA")
  if(151<=x&x<=200) return("MUY MALA")
  if(x>=201) return("EXTREMADAMENTE MALA")
})->newdata
  
data$Fecha2 <- paste(data$Fecha,data$Hora)
    
datar <- data[,c(1,2,grep("Noreste",colnames(data)))]
colnames(datar)[3:7] <- c("Ozono","Dióxido de Azufre",
                                 "Dióxido de Nitrogeno",
                                 "Monóxido de Carbono",
                                 "PM10")
 

       
