library(shinydashboard)


header <- dashboardHeader(
  title = "Calidad del Aire"
)
  


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Visualización", tabName = "viz", icon = icon("dashboard"))
  )
)
  


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "viz",
            h2("Gráficos"),
            fluidRow(
              box(
                selectInput("zona","Zona", choices = c("Noreste","Noroeste",
                                                       "Sureste","Suroeste",
                                                       "Centro")
                            ),
                width=4
                ),
              box(
                selectInput("var","Contaminante", choices = c("Ozono","Dióxido_de_Azufre",
                                                              "Dióxido_de_Nitrogeno",
                                                              "Monóxido_de_Carbono",
                                                              "PM10")
                            ),
                width=4
                )
            ),
            fluidRow(
              box(plotlyOutput("serie"), width = 8, height = 400)
            ),
            fluidRow(
              box(webGLOutput("glplot"), width = 8, height = 400)
              )
            )
    )
)
  


dashboardPage(header, sidebar, body)
    
   
  

