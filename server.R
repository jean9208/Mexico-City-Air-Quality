Sys.setlocale("LC_ALL", "es_MX.UTF-8")

library(dplyr)

shinyServer(function(input, output) {


#Enlaces a los archivos

link <- "http://148.243.232.112:8080/opendata/IndiceCalidadAire/indice_2016.csv"

#Carga de la informacion
datos <- read.csv(link,skip = 9, stringsAsFactors = F, encoding = "latin1", header = F)

#Pegar nombres
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

colnames(datos) <- data_names

#Borrar columnas de mas
datos<-datos[datos$Fecha!="",seq(1,ncol(datos)-2)]
datos[is.na(datos)==T] <- 0

filtro <- reactive({
  data_reduced <- datos[,c(1,2,grep(input$zona,colnames(datos)))]
  colnames(data_reduced)[3:7] <- c("Ozono","Dióxido_de_Azufre",
                                   "Dióxido_de_Nitrogeno",
                                   "Monóxido_de_Carbono",
                                   "PM10")
  return(data_reduced)
})

#Scatterplot

output$serie <- renderPlotly({
  datar <- filtro()
  datar %>% select_(~ Fecha,Contaminante=input$var) -> datar
  lapply(datar$Contaminante, function(x){
    if(x<=50) return("BUENA")
    if(51<=x&x<=100) return("REGULAR")
    if(101<=x&x<=150) return("MALA")
    if(151<=x&x<=200) return("MUY MALA")
    if(x>=201) return("EXTREMADAMENTE MALA")
  })->newdata
  datar$Categoría <- unlist(newdata)
  plot_ly(datar, x = Fecha, y = Contaminante, mode = "markers", color = Categoría)
})

output$glplot <- renderWebGL({
  data <- filtro()
  pc <- princomp(data[,3:ncol(data)], cor=TRUE, scores=TRUE)
  km <- kmeans(data[,3:ncol(data)],3)
  data$cluster <- as.factor(km$cluster)
  plot3d(pc$scores[,1:3], col=data$cluster, main="k-means clusters")
})

})