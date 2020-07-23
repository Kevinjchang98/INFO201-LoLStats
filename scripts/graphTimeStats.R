graph_time_stats_plotly <-
  function(xDataIn, yDataIn, winIn, xNameIn, yNameIn, includeFit) {
  df <- data.frame(xData = xDataIn,
                   yData = yDataIn,
                   win = winIn,
                   stringsAsFactors = FALSE)

  df <- df %>% mutate(
    winString = ifelse(win,
           "Won",
           "Lost")
     )

  return_plot <- plot_ly(data = df,
                         x = ~xData,
                         y = ~yData
                         )

  return_plot <- add_markers(return_plot,
                             y = ~yData,
                             text = ~xData,
                             color = ~winString,
                             colors = c("orange",
                                        "blue"),
                             showlegend = FALSE)

  if (includeFit) {
    m <- loess(yData ~ xData, data = df)

    return_plot <- add_lines(return_plot,
                             y = ~fitted(loess(yData ~ xData)),
                             line = list(color = "rgba(241, 133, 54, 0.9)"),
                             name = "Loess Curve Fit",
                             showlegend = FALSE)

    return_plot <- add_ribbons(return_plot,
                               data = augment(m),
                               ymin = ~.fitted - 1.96 * .se.fit,
                               ymax = ~.fitted + 1.96 * .se.fit,
                               line = list(color = "rgba(56, 119, 175, 0.1)"),
                               fillcolor = "rgba(56, 119, 175, 0.2)",
                               name = "Standard Error Bounds",
                               showlegend = FALSE
    )
  }

  xNames <- c(
    "gameNum" = "Game Number",
    "date" = "Date"
  )

  yNames <- c(
    "kills" = "Kills",
    "deaths" = "Deaths",
    "assists" = "Assists",
    "totalDamageDealt" = "Total Damage",
    "magicDamageDealt" = "Magic Damage",
    "physicalDamageDealt" = "Physical Damage",
    "trueDamageDealt" = "True Damage",
    "totalDamageDealtToChampions" = "Champion Damage",
    "damageDealtToObjectives" = "Objective Damage",
    "damageDealtToTurrets" = "Tower Damage",
    "totalDamageTaken" = "Damage Taken",
    "goldEarned" = "Gold Earned",
    "turretKills" = "Tower Kills",
    "totalCreepScore" = "CS",
    "visionScore" = "Vision Score"
  )

  return_plot <- return_plot %>%
    layout(xaxis = list(title = xNames[[xNameIn]]),
           yaxis = list(title = yNames[[yNameIn]]))

  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")

  return(return_plot)
}