server <- function(input, output) {
  start_time <- Sys.time() # Record time after initial requests made
  message(paste0("Initial Data Retrieved at ", start_time))

  # When button pressed by user
  observeEvent(
    eventExpr = input[["submit_loc"]],
    handlerExpr = {
      request_time <- Sys.time() # Recod time button was pressed
      name <<- input$accountName
      region <<- input$region
      numGames <<- input$numGames
      rankedInfoString <- print_ranked_data(name, region, apiKey)

      output$basicInfo <- renderText({
        rankedInfoString
      })

      if (rankedInfoString != "Could not get ranked data.") {

        # Get path to ranked league icon
        leagueString <- strsplit(rankedInfoString, " ")[[1]][5]
        leagueString <- paste(toupper(substring(leagueString, 1, 1)),
                              substring(leagueString, 2),
                              sep = "", collapse = " ")
        leagueString <- paste0("Emblem_",
                               leagueString,
                               ".png")

        pathToImage <- reactive({
          leagueString
        })

        output$leagueImage <- renderUI({
          tags$img(src = pathToImage(),
                   style = "width: 25%")
        })
      }

      # Min seconds between page's first requests and when user clicks button
      # before computer 120 seconds - debugWaitTime If debugWaitTime is 120,
      # then page will be open for at least 2 mins between initial requests and
      # button press, allowing for 100 matches to be gotten.
      # TODO: Maybe make condition where this only happens if above 90 matches
      # requested as it seems like anything under 90 always works?
      debugWaitTime <- 2

      if ((request_time - start_time) > debugWaitTime) {
        source("app_data.R")
      } else {
        withProgress(message = "Rate limit", value = 0, {
          wait_time <-
            as.numeric(round((debugWaitTime - (request_time - start_time)),
                             digits = 0))
          for (n in 1:wait_time) {
            incProgress(amount = 1 / wait_time, detail =
                          paste0("Waiting for ",
                                 wait_time - n,
                                 " more seconds"))
            Sys.sleep(1)
          }
        })
        source("app_data.R")
      }
      withProgress(message = "Creating Graphs: ", value = 0, {
        numGraphs <- 9
        # Create all output graphs

        incProgress(amount = 1 / numGraphs, detail = "Champion")
        output$graphChampion <-
          renderPlotly(graph_champion_freq_plotly(champion_summary))

        incProgress(amount = 1 / numGraphs, detail = "Time")
        output$graphTime <-
          renderPlotly(graph_time_plotly(time_summary))

        incProgress(amount = 1 / numGraphs, detail = "Winrate Pie")
        output$graphWinratePie <-
          renderPlotly(graph_winrate_pie_plotly(winrate_data))

        incProgress(amount = 1 / numGraphs, detail = "KDA Pie")
        output$graphKDAPie <-
          renderPlotly(graph_kda_pie_plotly(match_summary))

        incProgress(amount = 1 / numGraphs, detail = "Roles Pie")
        output$graphRolePie <-
          renderPlotly(graph_role_pie_plotly(match_summary))

        incProgress(amount = 1 / numGraphs, detail = "KDA")
        output$graphWinKDA <-
          renderPlotly(graph_winrate_kda_plotly(win_summary))
        incProgress(amount = 1 / numGraphs, detail = "Damage")
        output$graphWinDmg <-
          renderPlotly(graph_winrate_dmg_plotly(win_summary))
        incProgress(amount = 1 / numGraphs, detail = "Gold")
        output$graphWinGold <-
          renderPlotly(graph_winrate_gold_plotly(win_summary))
        incProgress(amount = 1 / numGraphs, detail = "CS")
        output$graphWinCS <- renderPlotly(graph_winrate_cs_plotly(win_summary))
      })

      output$graphTimeStats <- renderPlotly({
        if (input$timeGraphXData == "date") {
          return_graph <-
            graph_time_stats_plotly(recent_match_data[[input$timeGraphXData]],
                                    recent_match_data[[input$timeGraphYData]],
                                    recent_match_data$win,
                                    input$timeGraphXData,
                                    input$timeGraphYData,
                                    FALSE)
        } else {
          return_graph <-
            graph_time_stats_plotly(recent_match_data[[input$timeGraphXData]],
                                    recent_match_data[[input$timeGraphYData]],
                                    recent_match_data$win,
                                    input$timeGraphXData,
                                    input$timeGraphYData,
                                    TRUE)
        }
        return_graph
      })

      # Create champion summary table
      output$tableChampion <- DT::renderDataTable(DT::datatable({
        return_table <- format_summary_table(champion_summary)

        if (input$championSelect != "All") {
          return_table <-
            return_table[return_table$Champion == input$championSelect, ]
        }

        if (input$winLossSelect != "All") {
          return_table <-
            return_table[return_table$`Win/Loss` == input$winLossSelect, ]
        }

        return_table
      }))
    }
  )
}