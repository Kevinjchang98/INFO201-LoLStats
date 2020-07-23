shinyServer(
  pageWithSidebar(
    headerPanel("LoL Stats"),
    
    sidebarPanel("Account Info",
      textInput("nameInput", "Name", ""),
      
      selectInput("region", "Region:",
                  c("NA" = "na1",
                    "EUW" = "euw1",
                    "KR" = "kr")),
      
      actionButton(
        inputId = "submit_loc",
        label = "Get stats"
      )
    ),
    mainPanel("Stats",
      
     # verbatimTextOutput("url1"),
     # verbatimTextOutput("url2"),
      textOutput("basicInfo")
    )
  )
)

