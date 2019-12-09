#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(dplyr)

# Define UI for application that draws a bar chart
shinyUI(fluidPage(

    # Application title
    titlePanel("Number of students in the Netherlands in 2018"),

    # Sidebar with 2 checkboxes to check parttime students on/off
    sidebarLayout(position = "left",
                  sidebarPanel("Fulltime and/or Parttime",
            checkboxInput("Fulltime", "Show/hide parttime students for number of students divided by city", value = FALSE),
            checkboxInput("Fulltime2", "Show/hide parttime students for number of students divieded by specialization", value = FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(8,plotlyOutput(outputId="plot1", width="600px",height="300px")),  
                column(8,plotlyOutput(outputId="plot2", width="600px",height="300px"))
            )
        )
    )
))


