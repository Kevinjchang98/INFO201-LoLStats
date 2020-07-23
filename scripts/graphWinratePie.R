theme_set(theme_minimal())

graph_winrate_pie <- function(winrate) {

  return_plot <- ggplot(winrate,
      aes(x = "",
          y = freq,
          fill = factor(winInt, labels = c("Loss", "Win")))) +
    geom_bar(width = 1,
             stat = "identity") +
    coord_polar("y", start = 0) +
    geom_text(aes(label = freq),
              position = position_stack(vjust = 0.5),
              color = "white",
              size = 10) +
    theme(panel.grid = element_blank(),
          axis.text = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          legend.position = "none")

  return(return_plot)
}

graph_winrate_pie_plotly <- function(winrate) {

  winrate <- winrate_data

  winrateValue <- (
    winrate[winrate$winInt == 1, "freq"] /
    sum(winrate$freq))
  winrateValue <- label_percent()(as.numeric(winrateValue))

  return_plot <- plot_ly(winrate,
                         labels = ~factor(winInt, labels = c("Losses", "Wins")),
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
    layout(annotations = list(text = winrateValue,
                              "showarrow" = F,
                              font = list(size = 18)))
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")


  return(return_plot)
}