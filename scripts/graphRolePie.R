graph_role_pie_plotly <- function(match_summary) {

  df <- match_summary %>%
    select(role, lane) %>%
    mutate(position = ifelse(
      role == "SOLO",
      ifelse( # if solo
        lane == "MID", # and lane is mid
        "Middle", # then pos = middle
        "Top" # otherwise pos = top
      ),
      ifelse( # if not solo
        role == "DUO_CARRY", # if role is duo carry
        "ADC", # then pos = ADC
        ifelse( # if not solo or carry
          role == "DUO_SUPPORT", # if role is support
          "Support", # then pos = support
          ifelse( # if not solo, carry, support
            role == "DUO", # if role is duo
            ifelse( # then
              lane == "MID", # if lane is also mid
              "Middle", # then position is middle
              "Top" # otherwise it's p[]
            ), # if role is not duo
            ifelse( # then
              role == "NONE", # if role is none
              ifelse(
                lane == "JUNGLE", # and lane is jungle
                "Jungle", # then pos = jungle
                "Unknown" # otherwise unknown
              ),
              "Unknown"
            )
          )
        )
      )
    )) %>%
    group_by(position) %>%
    summarize(freq = n())

  return_plot <- plot_ly(df,
                         labels = ~position,
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
    layout(annotations = list(text = "Roles",
                              "showarrow" = F,
                              font = list(size = 18)))
  return_plot <- return_plot %>%
    layout(plot_bgcolor  = "rgba(0, 0, 0, 0)",
           paper_bgcolor = "rgba(0, 0, 0, 0)",
           fig_bgcolor   = "rgba(0, 0, 0, 0)")

  return(return_plot)
}