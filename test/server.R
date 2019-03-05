
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  output$ex1 <- DT::renderDataTable(
    DT::datatable(
      iris, options = list(
        lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
        pageLength = 15
      )
    )
  )
  output$downloadData <- downloadHandler(
    filename = function(){
      paste("iris-data",sep=".","csv")
    },
    content = function(file){
      write.csv(iris,file)
    }
  )
    
    
    
  output$distPlot <- renderPlotly({
    withProgress({
      setProgress(message = "Processing...")
      Sys.sleep(1.5)
    data <- iris
    if (input$species != "All") {
      data <- data[data$Species == input$species,]
    }
    
    if(input$x=='a'){
      m<-iris$Sepal.Length
      #i<-~Sepal.Length
      
    }
    
    if(input$x=='b'){
      #i<-~Sepal.Width
      m<-iris$Sepal.Width
    }
    
    if(input$x=='c'){
      #i<-~Petal.Length
      m<-iris$Petal.Length
    }
    
    if(input$x=='d'){
      #i<-~Petal.Width
      m<-iris$Petal.Width
    }
    
    if(input$y=='e'){
      #j<-~Sepal.Length
      n<-iris$Sepal.Length
    }
    
    if(input$y=='f'){
      #j<-~Sepal.Width
      n<-iris$Sepal.Width
    }
    
    if(input$y=='g'){
      #j<-~Petal.Length
     n<-iris$Petal.Length
    }
    
    if(input$y=='h'){
      #j<-~Petal.Width
      n<-iris$Petal.Width
    }
    #key <- row.names(iris)
    if (identical(input$plotType, "ggplotly")) {
      p <- ggplot(iris, aes(x = m, y = n, colour = factor(Species))) + 
        geom_point()
      ggplotly(p) %>% layout(dragmode = "select")
    } else if(identical(input$plotType, "plotly")) {
      plot_ly(iris, x = m, y = n) %>%
        layout(dragmode = "select")
    }
    else
    {
      plot_ly(data = data, x = m, y = n , type = 'bar', title = 'IRIS') 
    }
    
    
    
    
    
  })
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point/bar" else d
  })
  
  
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    iris[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
   # par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function(){
      paste("iris-plot",sep=".",switch(
        input$format, PDF = "pdf", PNG = "png"
      ))
    },
    content = function(file)
    {
      if(input$format == "PDF")
      {
        pdf(file)
      }
      else if(input$format == "PNG")
      {
        png(file)
      }
      
      plot(selectedData(),
           col = clusters()$cluster,
           pch = 20, cex = 3)
      points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
      dev.off()
    }
  )
  
  
  
})
  
