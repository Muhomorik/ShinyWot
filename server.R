
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(curl)
library(shiny)

library(jsonlite)
library(dplyr)
library(ggplot2)

# http://stackoverflow.com/questions/16848352/r-and-shiny-pass-inputs-from-sliders-to-reactive-function-to-compute-output

shinyServer(function(input, output) {

  source("LoadTanks.R", local=TRUE)
  source("LoadStats.R", local=TRUE)
  source("Helpers.R", local=TRUE)
  
  # Request
  req.fields <- c("tank_id", "random")
  req.extra <- "random"
  
  Vehicles <- loadTankList()
  
  url <- reactive({
    createUrlVehicleStats(
      req.fields, req.extra, input$accountid, input$inGarage, "ru")})

  
  # Avg damage vs WinRate
  output$avgDmg_vs_winrate <- renderPlot({
    
    VehicleStats <- loadPlayerStats(url())
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filT <- reactive({
      filterDf(df, input$tier[1], input$tier[2])
    })
    
    p <- ggplot(filT(), aes(avg.DamageDealt, winRate, label = name)) 
    p <- p + geom_point()
    p <- p + facet_grid(type~.)
    p <- p + geom_text(check_overlap = TRUE)
    p <- p + geom_smooth(method=lm)
    p
   })
  
  # spotted vs avg dmg.
  output$spotted_vs_winrate <- renderPlot({
    
    VehicleStats <- loadPlayerStats(url())
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filT <- reactive({
      filterDf(df, input$tier[1], input$tier[2])
    })
    
    p <- ggplot(filT(), aes(avg.Spotted, winRate, label = name)) 
    p <- p + geom_point()
    p <- p + facet_grid(type~.)
    p <- p + geom_text(check_overlap = TRUE)
    p <- p + geom_smooth(method=lm)
    p
  })
  
  # battles fought histogram.
  output$battlesFought_hist <- renderPlot({
    
    VehicleStats <- loadPlayerStats(url())
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filT <- reactive({
      filterDf(df, input$tier[1], input$tier[2])
    })
    
    hist(filT()$random.battles, breaks = 34, col = "grey", las = 3)
  })  

  # battles fought histogram.
  output$winrate_hist <- renderPlot({
    
    VehicleStats <- loadPlayerStats(url())
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filT <- reactive({
      filterDf(df, input$tier[1], input$tier[2])
    })
    
    hist(filT()$winRate, breaks = 34, col = "grey", las = 3)
  })  
  
  # rnorn for winrate.
  output$winrate_dnorm <- renderPlot({
    
    VehicleStats <- loadPlayerStats(url())
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filT <- reactive({
      filterDf(df, input$tier[1], input$tier[2])
    })
    
    winRate.sd = sd(filT()$winRate, na.rm = TRUE)
    winRate.mean = mean(filT()$winRate, na.rm = TRUE)  
    
    plot(filT()$winRate, dnorm(filT()$winRate, mean=winRate.mean, sd=winRate.sd),col=2, lwd=2) 
  })    
})
