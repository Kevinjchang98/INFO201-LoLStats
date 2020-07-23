## Player specific data
# Basic sentence getting current solo queue status
ranked_summary <<- get_ranked_data(name, region, apikey)

# Get most recent matches and its data
match_summary <<- data.frame()
match_summary <<- get_match_data(name, region, apikey) %>%
  mutate(gameChampId = paste(gameId, champion))

# For debugging, set flag to TRUE to auto wait for 2 mins
# Obsolete in Shiny App by app_server.R's debugWaitTime
if (FALSE) {
  message("Waiting 2 mins for rate limit")
  n <- 0
  for (n in seq(from = 1, to = 120, by = 1)) {
    Sys.sleep(1)
    message(120 - n)
  }
}

# numGames requests
recent_match_data <<- data.frame()

match_summary <- head(match_summary, n = numGames)

recent_match_data <<- get_recent_match_data(match_summary$gameChampId)

Sys.sleep(1)

recent_match_data$gameChampId <-
  match_summary$gameChampId[1:nrow(recent_match_data)]

withProgress(message = "Analyzing Data: ", value = 0, {
  numSteps <- 5
  incProgress(amount = 1 / numSteps, detail = "Match Summary")
  match_summary <<- left_join(match_summary, recent_match_data) %>%
    mutate(winInt = as.integer(as.logical(win)),
           timeLong = anytime(timestamp / 1000),
           date = as.Date(timeLong),
           time = format(timeLong, "%H:%M:%S"),
           hour = as.numeric(format(
             strptime(match_summary$time, "%H:%M:%S"), "%H")),
           totalCreepScore = neutralMinionsKilled + totalMinionsKilled
    ) %>%
    dplyr::rename(key = champion)

  incProgress(amount = 1 / numSteps, detail = "Match Summary")
  match_summary <<- match_summary %>%
    mutate(hour = as.numeric(format(
      strptime(match_summary$time, "%H:%M:%S"), "%H")))
  Sys.sleep(1)


  incProgress(amount = 1 / numSteps, detail = "Champion Summary")
  # Data per champion played
  champion_summary <<- data.frame()
  champion_summary <<- match_summary %>%
    left_join(champion_constants %>%
                select(key, name)) %>%
    group_by(name, winInt) %>%
    dplyr::summarize(freq = dplyr::n(),
                     avgKills = mean(kills),
                     avgDeaths = mean(deaths),
                     avgAssists = mean(assists),
                     avgKDA = (avgKills + avgAssists) / avgDeaths,
                     avgTotDmg = mean(totalDamageDealt),
                     avgVisionScore = mean(visionScore),
                     avgGoldEarned = mean(goldEarned),
                     avgCS = mean(totalMinionsKilled + neutralMinionsKilled))

  incProgress(amount = 1 / numSteps, detail = "Win Summary")
  # Data based on win/loss
  win_summary <<- match_summary %>%
    group_by(winInt) %>%
    dplyr::summarize(freq = dplyr::n(),
                     avgKills = mean(kills),
                     avgDeaths = mean(deaths),
                     avgAssists = mean(assists),
                     avgKDA = (avgKills + avgAssists) / avgDeaths,
                     avgTotDmg = mean(totalDamageDealt),
                     avgVisionScore = mean(visionScore),
                     avgGoldEarned = mean(goldEarned),
                     avgCS = mean(totalMinionsKilled + neutralMinionsKilled),
                     sigmaKills = sd(kills),
                     sigmaDeaths = sd(deaths),
                     sigmaAssists = sd(assists),
                     sigmaKDA = sqrt(
                       (sqrt(sigmaKills^2 + sigmaAssists^2) /
                          (avgAssists + avgKills))^2 +
                         (sigmaDeaths / avgDeaths)^2),
                     sigmaTotDmg = sd(totalDamageDealt),
                     sigmaVisionScore = sd(visionScore),
                     sigmaGoldEarned = sd(goldEarned),
                     sigmaCS = sqrt(sd(totalMinionsKilled)^2 +
                                      sd(neutralMinionsKilled)^2)
    ) %>%
    mutate(win = ifelse(
      winInt == 1,
      "Win",
      "Loss"))

  incProgress(amount = 1 / numSteps, detail = "Time Summary")
  # Data based on time of day
  time_summary <<- match_summary %>%
    group_by(hour, winInt) %>%
    dplyr::summarize(freq = dplyr::n(),
                     avgKills = mean(kills),
                     avgDeaths = mean(deaths),
                     avgAssists = mean(assists),
                     avgKDA = (avgKills + avgAssists) /
                       avgDeaths,
                     avgTotDmg = mean(totalDamageDealt),
                     avgVisionScore = mean(visionScore),
                     avgGoldEarned = mean(goldEarned),
                     avgCS = mean(totalMinionsKilled +
                                    neutralMinionsKilled),
                     sigmaKills = sd(kills),
                     sigmaDeaths = sd(deaths),
                     sigmaAssists = sd(assists),
                     sigmaKDA = sqrt(
                       (sqrt(sigmaKills^2 + sigmaAssists^2) /
                          (avgAssists + avgKills))^2 +
                         (sigmaDeaths / avgDeaths)^2),
                     sigmaTotDmg = sd(totalDamageDealt),
                     sigmaVisionScore = sd(visionScore),
                     sigmaGoldEarned = sd(goldEarned),
                     sigmaCS = sqrt(sd(totalMinionsKilled)^2 +
                                      sd(neutralMinionsKilled)^2)
    ) %>%
    mutate(win = ifelse(
      winInt == 1,
      "Win",
      "Loss"))

  incProgress(amount = 1 / numSteps, detail = "Winrate Data")

  # Add data for timeStatsGraph
  recent_match_data$date <-
    match_summary$date[1:nrow(recent_match_data)]
  recent_match_data$totalCreepScore <-
    match_summary$totalCreepScore[1:nrow(recent_match_data)]
  recent_match_data$gameNum <-
    nrow(recent_match_data) - as.numeric(rownames(recent_match_data)) + 1

  # Winrate
  info_winrate <<- mean(match_summary$winInt)

  winrate_data <<- win_summary[1:2, 1:2]

})