# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(readxl)
library(dplyr)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
    #loading the data
    fileURL <- "https://www.duo.nl/open_onderwijsdata/images/02-ingeschrevenen-wo-naar-opleidingsvorm-2018.xlsx"
    download.file(fileURL,destfile = "data.xlsx",mode = "wb")
    mydata <- read_excel("data.xlsx")
    names(mydata) <- gsub(" ", "_", names(mydata))
    
        #Prepare data numbers of students per city
        mydata1 <- mydata %>%
            filter(!is.na(BEVOEGD_GEZAG_NUMMER)) %>%
            group_by(PLAATSNAAM) %>%
            summarize(voltijd = sum(VOLTIJD_ONDERWIJS), deeltijd = sum(DEELTIJD_ONDERWIJS), count = n()) %>%
            mutate(combined = voltijd + deeltijd) %>%
            arrange(desc(voltijd))
        mydata2 <- mydata1 %>%
            arrange(desc(deeltijd))
        
        mydata1$PLAATSNAAM <- factor(mydata1$PLAATSNAAM, levels = c(as.character(mydata1$PLAATSNAAM)))
        mydata2$PLAATSNAAM <- factor(mydata2$PLAATSNAAM, levels = c(as.character(mydata2$PLAATSNAAM)))
        
        #Prepare data for number of students per specialization
        mydata3 <- mydata %>%
            filter(!is.na(BEVOEGD_GEZAG_NUMMER)) %>%
            group_by(CROHO_ONDERDEEL) %>%
            summarize(voltijd = sum(VOLTIJD_ONDERWIJS), deeltijd = sum(DEELTIJD_ONDERWIJS), count = n()) %>%
            mutate(combined = voltijd + deeltijd) %>%
            arrange(desc(voltijd)) 
        
        mydata4 <- mydata3 %>%
            arrange(desc(deeltijd))
        
        mydata3$CROHO_ONDERDEEL <- factor(mydata3$CROHO_ONDERDEEL, levels = c(as.character(mydata3$CROHO_ONDERDEEL)))
        mydata4$CROHO_ONDERDEEL <- factor(mydata4$CROHO_ONDERDEEL, levels = c(as.character(mydata4$CROHO_ONDERDEEL)))
        
        #Make the plots for number of studens per city
        p_vol_deel <- plot_ly(x=mydata1$PLAATSNAAM, y=mydata1$voltijd, type = "bar", name = "Fulltime + Parttime") %>%
            add_trace(y = mydata1$deeltijd, name = "Parttime") %>%
            layout(title = "Number of students (fulltime/parttime) per city", yaxis = list(title = 'Amount'), 
                   xaxis = list(title = "City"), barmode = 'stack')

        p_vol <- plot_ly(x=mydata1$PLAATSNAAM, y=mydata1$voltijd, type = "bar", name = "Voltijd") %>%
           layout(title = "Number of fulltime students per city", yaxis = list(title = 'Amount'), 
                   xaxis = list(title = "City"), barmode = 'stack')
        
        #Make the plots for number of students per specialization
        p2_vol_deel <- plot_ly(x=mydata3$CROHO_ONDERDEEL, y=mydata3$voltijd, type = "bar", name = "Fulltime + Parttime") %>%
            add_trace(y = mydata3$deeltijd, name = "Parttime") %>%
            layout(title = "Number of students (fulltime/parttime) per specialization", yaxis = list(title = 'Amount'), 
                   xaxis = list(title = "City"), barmode = 'stack')
        
        p2_vol <- plot_ly(x=mydata3$CROHO_ONDERDEEL, y=mydata3$voltijd, type = "bar", name = "Voltijd") %>%
            layout(title = "Number of fulltime students per specialization", yaxis = list(title = 'Amount'), 
                   xaxis = list(title = "City"), barmode = 'stack')
        
        #Render the plots to shiny app
        output$plot1 <- renderPlotly({
            if(input$Fulltime){plot1 = p_vol_deel}
            else{plot1=p_vol}})

        output$plot2 <- renderPlotly({
            if(input$Fulltime2){plot2 = p2_vol_deel}
            else{plot2 = p2_vol}})

})

