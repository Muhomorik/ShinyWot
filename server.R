
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

# http://shiny.rstudio.com/articles/action-buttons.html
# http://shiny.rstudio.com/tutorial/lesson6/

# The function that you pass to shinyServer() is called once for each session. 
# In other words, func is called each time a web browser is pointed to the Shiny application.

# A read-only data set that will load once, when Shiny starts, and will be
# available to each user session

# A non-reactive function that will be available to each user session

source("cfg.R")
token <- GetWgApiKey()

source("LoadTanks.R", local=TRUE)
Vehicles <- LoadTankList(token)

shinyServer(function(input, output) {

  # Other objects inside the function, such as variables and functions, 
  # are also instantiated for each session. 
  
  # Can create a local variable varA, which will be a copy of the shared variable
  # varA plus 1. This local copy of varA is not be visible in other sessions.
  # With <- or change the global var with <<-.
  
  source("LoadStats.R", local=TRUE)
  source("Helpers.R", local=TRUE)
  
  # Request
  req.fields <- c("tank_id", "random")
  req.extra <- "random"
  
  # Load (reactive) and filter data based on input.
  LoadVehicleStats <- reactive({
    url <- CreateUrlVehicleStats("ru", token, 
      req.fields, req.extra, input$accountid, input$inGarage)
    
    VehicleStats <- 
      LoadPlayerStats(url)
    
    df <- VehicleStats %>% 
      inner_join(Vehicles, by="tank_id")
    
    filterDf(df, input$tier[1], input$tier[2])
  })
    
  # Avg damage vs WinRate
  output$avgDmg_vs_winrate <- renderPlot({
    
    p <- ggplot(LoadVehicleStats(), aes(avg.DamageDealt, winRate, label = name)) 
    p <- p + geom_point(aes(color = tier))
    p <- p + facet_grid(type~.)
    p <- p + geom_text(check_overlap = TRUE)
    p <- p + geom_smooth(method=lm)
    p <- p + labs(title ="Average Dmg vs Win ratio", x = "Damage", y = "Win ratio")
    p
   })
  
  # spotted vs winRate.
  output$spotted_vs_winrate <- renderPlot({
    
    p <- ggplot(LoadVehicleStats(), aes(avg.Spotted, winRate, label = name)) 
    p <- p + geom_point(aes(color = tier))
    p <- p + facet_grid(type~.)
    p <- p + geom_text(check_overlap = TRUE)
    p <- p + geom_smooth(method=lm)
    p <- p + labs(title ="Spottd tanks vs Win ratio", x = "Spotted tanks", y = "Win ratio")
    p
  })
  
  # battles fought histogram.
  output$battlesFought_hist <- renderPlot({
  
    p <- ggplot(LoadVehicleStats(), aes(random.battles)) 
    p <- p + geom_histogram(bins = 34, colour="white")
    p <- p + labs(title ="Battles fought histogram", x = "Win ratio", y = "Count")
    p
  })  

  # winrate histogram/density.
  output$winrate_hist <- renderPlot({
    # TODO: this one draws double lines with color!
    mean <- mean(LoadVehicleStats()$winRate)
    
    p <- ggplot(LoadVehicleStats(), aes(x=winRate)) 
    p <- p + geom_histogram(aes(y=..density..),bins = 32, colour="white")
    p <- p + geom_vline(xintercept = mean, show.legend = TRUE,
                        linetype="dashed", size=1)
    p <- p + labs(title ="Win ratio density", x = "Win ratio", y = "Density")
    p <- p + geom_density(aes(winRate, alpha=.2, color=tier), size=0.5)
    p

  })  
  
  # rnorn for winrate.
  output$winrate_dnorm <- renderPlot({
    
    winRate.sd = sd(LoadVehicleStats()$winRate, na.rm = TRUE)
    winRate.mean = mean(LoadVehicleStats()$winRate, na.rm = TRUE)  
    
    plot(LoadVehicleStats()$winRate, dnorm(LoadVehicleStats()$winRate, mean=winRate.mean, sd=winRate.sd),col=2, lwd=2) 
  })    
})
