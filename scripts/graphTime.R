graph_time <- function(time_summary) {
  return_plot <- ggplot(time_summary,
         aes(x = hour,
             y = freq,
             group = factor(winInt))) +
    geom_col(aes(fill = factor(winInt, labels = c("Loss", "Win"))),
             width = 0.7) +
    scale_x_continuous(breaks = seq(0, 24, by = 1),
                       limits = c(0, 24)) +
    labs(x = "Hour of Game Start",
         y = "Number of Games",
         fill = "Game outcome"
         ) +
    ggtitle("Games by Time Started")

  return(return_plot)
}

graph_time_plotly <- function(time_summary) {
  winData <- time_summary %>%
    filter(winInt == 1)
  lossData <- time_summary %>%
    filter(winInt == 0)
  return_plot <- plot_ly(winData,
                         x = ~hour,
                         y = ~freq,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~hour,
              y = ~freq,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Number of Games Played"),
           xaxis = list(title = "Hour of Day of Game Start"),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}