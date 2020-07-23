library(httr)
library(jsonlite)
library(dplyr)

source("./scripts/apikey.R")
source("./scripts/get.R")

shinyServer(
  function(input, output){
    observeEvent(
      eventExpr = input[["submit_loc"]],
      handlerExpr = {
        accountName = input$nameInput
        region = input$region
        
         
        output$basicInfo <- renderText({
          printRankedData(accountName, region, apiKey)
        })
      }
    )
  }
)