
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyUI(fluidPage(
  
  navbarPage(
    title = 'IRIS DATASET',
    tabPanel('K-Means',pageWithSidebar(
      headerPanel('k-means clustering'),
      sidebarPanel(
        selectInput('xcol', 'X Variable', names(iris[1:4])),
        selectInput('ycol', 'Y Variable', names(iris[1:4]),
                    selected=names(iris)[[2]]),
        numericInput('clusters', 'Cluster count', 3,
                     min = 1, max = 9),
        radioButtons('format', 'Document format', c('PDF', 'PNG'),
                     inline = TRUE),
        downloadButton("downloadPlot", "Download Plot")
      ),
      mainPanel(
        plotOutput('plot1')
      )
    )),
    
    tabPanel('Explanatory Analysis',sidebarLayout(
      sidebarPanel(
        #taking inputs using radiobuttons
        fluidRow(
          radioButtons("plotType", "Plot Type:", choices = c("ggplotly", "plotly","plotly-column")),
          column(4,
                 selectInput("species",
                             "Species:",
                             c("All",
                               unique(as.character(iris$Species))))
          )),
        br(),
        
        radioButtons("x", "Select X-axis:",
                     list("Sepal.Length"='a', "Sepal.Width"='b', "Petal.Length"='c', "Petal.Width"='d')),
        radioButtons("y", "Select Y-axis:",
                     list("Sepal.Length"='e', "Sepal.Width"='f', "Petal.Length"='g', "Petal.Width"='h'))
      ),
      
      #displaying the output plot
      mainPanel(
        #plotOutput("distPlot")
        plotlyOutput("distPlot"),
        verbatimTextOutput("event")
      )
    )),
    
    
    
    tabPanel('Show Data',downloadButton("downloadData", "Download Data"),br(),hr(),DT::dataTableOutput('ex1'))
    

  )
))
