
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  plotOutput("plot"),
  sliderInput("n", "Number of observations", 1, nrow(faithful), 100),
  bookmarkButton()

  
))
