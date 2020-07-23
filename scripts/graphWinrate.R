theme_set(theme_minimal())

graph_winrate <- function(win_summary) {
  graph_kda <- ggplot(data = win_summary) +
    geom_col(mapping = aes(x = win, y = avgKDA, fill = win)) +
    geom_errorbar(aes(ymin = avgKDA - sigmaKDA,
                      ymax = avgKDA + sigmaKDA,
                      y = avgKDA,
                      x = win),
                  width = 0.2) +
    labs(x = "Win/Loss", y = "KDA")  +
    ggtitle("KDA") +
    theme(legend.position = "none")

  graph_dmg <- ggplot(data = win_summary) +
    geom_col(mapping = aes(x = win, y = avgTotDmg, fill = win)) +
    geom_errorbar(aes(ymin = avgTotDmg - sigmaTotDmg,
                      ymax = avgTotDmg + sigmaTotDmg,
                      y = avgTotDmg,
                      x = win),
                  width = 0.2) +
    labs(x = "Win/Loss", y = "Average Total Damage")  +
    ggtitle("Damage") +
    scale_y_continuous(labels = comma) +
    theme(legend.position = "none")

  graph_gold <- ggplot(data = win_summary) +
    geom_col(mapping = aes(x = win, y = avgGoldEarned, fill = win)) +
    geom_errorbar(aes(ymin = avgGoldEarned - sigmaGoldEarned,
                      ymax = avgGoldEarned + sigmaGoldEarned,
                      y = avgGoldEarned,
                      x = win),
                  width = 0.2) +
    labs(x = "Win/Loss", y = "Average Gold Earned")  +
    ggtitle("Gold Earned") +
    scale_y_continuous(labels = comma) +
    theme(legend.position = "none")

  graph_cs <- ggplot(data = win_summary) +
    geom_col(mapping = aes(x = win, y = avgCS, fill = win)) +
    geom_errorbar(aes(ymin = avgCS - sigmaCS,
                      ymax = avgCS + sigmaCS,
                      y = avgCS,
                      x = win),
                  width = 0.2) +
    labs(x = "Win/Loss", y = "Average CS")  +
    ggtitle("Creep Score") +
    scale_y_continuous(labels = comma) +
    theme(legend.position = "none")

  return(grid.arrange(graph_kda, graph_dmg, graph_gold, graph_cs,
                      nrow = 1))
}


graph_winrate_kda_plotly <- function(win_summary) {
  winData <- win_summary %>%
    filter(winInt == 1)
  lossData <- win_summary %>%
    filter(winInt == 0)

  return_plot <- plot_ly(winData,
                         x = ~win,
                         y = ~avgKDA,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~win,
              y = ~avgKDA,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Average KDA"),
           xaxis = list(title = ""),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}

graph_winrate_dmg_plotly <- function(win_summary) {
  winData <- win_summary %>%
    filter(winInt == 1)
  lossData <- win_summary %>%
    filter(winInt == 0)

  return_plot <- plot_ly(winData,
                         x = ~win,
                         y = ~avgTotDmg,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~win,
              y = ~avgTotDmg,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Average Total Damage Dealt"),
           xaxis = list(title = ""),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}

graph_winrate_gold_plotly <- function(win_summary) {
  winData <- win_summary %>%
    filter(winInt == 1)
  lossData <- win_summary %>%
    filter(winInt == 0)

  return_plot <- plot_ly(winData,
                         x = ~win,
                         y = ~avgGoldEarned,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~win,
              y = ~avgGoldEarned,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Average Gold Obtained"),
           xaxis = list(title = ""),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}

graph_winrate_cs_plotly <- function(win_summary) {
  winData <- win_summary %>%
    filter(winInt == 1)
  lossData <- win_summary %>%
    filter(winInt == 0)

  return_plot <- plot_ly(winData,
                         x = ~win,
                         y = ~avgCS,
                         type = "bar",
                         name = "Wins")
  return_plot <- return_plot %>%
    add_trace(data = lossData,
              x = ~win,
              y = ~avgCS,
              name = "Losses")
  return_plot <- return_plot %>%
    layout(yaxis = list(title = "Average Creep Score"),
           xaxis = list(title = ""),
           barmode = "stack")
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")
  return_plot <- return_plot %>%
    config(displayModeBar = FALSE)

  return(return_plot)
}