graph_kda_pie_plotly <- function(match_summary) {
  kills <- round(match_summary$kills, 2)
  deaths <- round(match_summary$deaths, 2)
  assists <- round(match_summary$assists, 2)
  kdaText <- paste0(
    round(mean(kills, na.rm = TRUE), 0),
    "/",
    round(mean(deaths, na.rm = TRUE), 0),
    "/",
    round(mean(assists, na.rm = TRUE), 0)
  )


  df <- data.frame("labels" = c("Kills", "Deaths", "Assists"))
  df$freq <- c(mean(kills, na.rm = TRUE),
               mean(deaths, na.rm = TRUE),
               mean(assists, na.rm = TRUE))

  return_plot <- plot_ly(df,
                         labels = ~labels,
                         values = ~freq)
  return_plot <- return_plot %>%
    add_pie(hole = 0.6)
  return_plot <- return_plot %>%
    layout(showlegend = F,
           xaxis = list(showgrid = FALSE,
                        zeroline = FALSE,
                        showticklabels = FALSE),
           yaxis = list(showgrid = FALSE,
                        zeroline = FALSE,
                        showticklabels = FALSE))
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)
  return_plot <- return_plot %>%
    layout(annotations = list(text = kdaText,
                              "showarrow" = F,
                              font = list(size = 18)))
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")

  return(return_plot)
}