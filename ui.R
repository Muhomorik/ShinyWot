
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
# http://shiny.rstudio.com/articles/layout-guide.html
# reactive : http://shiny.rstudio.com/tutorial/lesson6/
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("World of Tanks API fun"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      h6(strong("NaVi players: ")), 
      h6("LeBwa, Straik, Inspirer, TheAnatolich, SL1DE."),
      
      h6(strong("Good SPG players: ")),
      h6("Arti25, 19CaHTuMeTPoB, Alliluy."),
      
      h6(strong("Russian streamers: ")),
      h6("Vspishka, Gleborg, Amway921."),
      
      selectInput("accountid", label = "Select player ID", 
                  choices = list(
#                     "Me [EU]" = 500362266, 
#                     "Si3mka_[3XR] @EU" = 500094807,
                    
                    # KORM
                    "LeBwa[-KORM] @RU" = 486353,
                    "Straik[-KORM] @RU" = 73892,
                    "Inspirer[-KORM] @RU" = 28094,
                    "TheAnatolich[-KORM] @RU" = 6772102,
                    "SL1DE[-KORM] @RU" = 20847,

                    # Arty players
                    "Arti25[-KORM] @RU" = 1336557,
                    "19CaHTuMeTPoB[-KORM] @RU" = 14594911,
                    "Alliluy[-KORM] @RU" = 2952660,
                    
                    # Streamers
                    "Vspishka[-KORM] @RU" = 23363,
                    "Gleborg[-KORM] @RU" = 364846,
                    "Amway921[-KORM] @RU" = 855119
                    ), 
                  selected = 500362266),
      
#       selectInput("server", 
#                   label = "Server",
#                   choices = list("ru", "eu"),
#                   selected = "eu"),
      
      sliderInput("tier", 
                  label = "Vehicle tiers:",
                  min = 1, max = 10, value = c(6, 10)),
      
      checkboxInput("inGarage", label = "In garage", value = TRUE),
      
      helpText("Note: makes actual requests with 'demo' login. 
          May fail if requests/second 
         goes above limits."),

      p(tags$a(href = "https://github.com/Muhomorik/ShinyWot", 
               "Source code on GitHub")),
      
      h3("Wargaming API"),
      
      p(tags$a(href = "https://eu.wargaming.net/developers/api_reference/wot/encyclopedia/vehicles/", 
             "Vehicles in game")),
      
      p(tags$a(href = "https://eu.wargaming.net/developers/api_reference/wot/tanks/stats/", 
               "Vehicles statistics"))

      
    ), # http://shiny.rstudio.com/tutorial/lesson3/
    


    # Show a plot of the generated distribution
    mainPanel(
      
      h4(tags$div(
        HTML("<font color= #ff0000>This thing makes some HTTP calls, may be slow.</font>")
      )),
      
      h4("About"),
      p("This is my \"pet toy\" project. Once upon a time I use to play MMORPG World of Tanks."),
      p("The good thind is thet Wargaming provide an API (json)."),
      p("So I decided to take a look and make a simple app to perform requests and plot response. 
        The idea was to check how warious types of vehicles perform for the articular player."),

      h3("Battles fought histogam"),
      plotOutput("battlesFought_hist"),
      
      h3("WinRate density"),
      p("WinRate accumulated density with blan and density by tier with lines."),
      ("winrate_hist"),
      
      h3("dnorm for WinRate"),
      plotOutput("winrate_dnorm"),      
            
      h3("Average damage dealt vs Win ratio by Vehicle type"),
      plotOutput("avgDmg_vs_winrate"),
      
      h3("Spotted vs Win ratio by Vehicle type"),      
      plotOutput("spotted_vs_winrate")
    )
  )
))
