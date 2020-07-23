graph_champion_freq <- function(champion_summary) {
  theme_set(theme_minimal())

  return_plot <- ggplot(champion_summary,
                              aes(x = name,
                                  y = freq,
                                  group = factor(winInt))) +
  geom_col(aes(fill = factor(winInt, labels = c("Loss", "Win"))),
           width = 0.7) +
    labs(x = "Champion",
         y = "Number of Games Played",
         fill = "Game outcome") +
    ggtitle("Recent Champions Played") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

  return(return_plot)
}

graph_champion_freq_plotly <- function(champion_summary) {
  winData <- champion_summary %>%
    filter(winInt == 1)
  lossData <- champion_summary %>%
    filter(winInt == 0)
  return_plot <- plot_ly(winData,
                         x = ~as.character(name),
                         y = ~freq,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~as.character(name),
              y = ~freq,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Number of Games Played"),
           xaxis = list(title = "Champion"),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}