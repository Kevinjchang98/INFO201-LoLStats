summary <- function(name, region) {

  # Get updated information about champions
  champion_constants <<- get_champion_constants() %>%
    ldply(data.frame)

  champion_constants[, "key"] <-
    as.numeric(as.character(champion_constants[, "key"]))

  champion_constants <<-
    champion_constants[!duplicated(champion_constants$key), ]

  ## Player specific data
  # Basic sentence getting current solo queue status
  ranked_summary <<- get_ranked_data(name, region, apikey)

  # Get most recent matches and its data
  match_summary <<- data.frame()
  match_summary <<- get_match_data(name, region, apikey) %>%
    mutate(gameChampId = paste(gameId, champion))

  # This asks for 100 requests, which can easily hit the 100 requests per 2 min
  # rate limit so there's a Sys.sleep(120) before this to reset the timer
  #
  # get_win_boolean_list() function has a Sys.sleep(0.06) to prevent hitting the
  # 20 requests per 1 second rate limit
  if (FALSE) {
    message("Waiting 2 mins for rate limit")
    n <- 0
    for (n in seq(from = 1, to = 120, by = 1)) {
      Sys.sleep(1)
      message(120 - n)
    }
  }

  # 100 requests
  recent_match_data <<- data.frame()
  recent_match_data <<- get_recent_match_data(match_summary$gameChampId)
  Sys.sleep(1)

  match_summary <<- left_join(match_summary, recent_match_data) %>%
    mutate(winInt = as.integer(as.logical(win)),
           timeLong = anytime(timestamp / 1000),
           date = as.Date(timeLong),
           time = format(timeLong, "%H:%M:%S"),
           hour = as.numeric(format(
             strptime(match_summary$time, "%H:%M:%S"), "%H"))
    ) %>%
    dplyr::rename(key = champion)

  match_summary <<- match_summary %>%
    mutate(hour = as.numeric(format(
      strptime(match_summary$time, "%H:%M:%S"), "%H")))
  Sys.sleep(1)

  # Debug
  message("1")

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
                     avgCS = mean(totalMinionsKilled + neutralMinionsKilled),
                     avgWards = mean(wardsPlaced))

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
                     avgWards = mean(wardsPlaced),
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
                     avgWards = mean(wardsPlaced),
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

  # Winrate
  info_winrate <<- mean(match_summary$winInt) %>%
    label_percent()()


  # Account Name
  info_account_name <<- ranked_summary[["name"]]

  # Rank
  info_rank <<- ranked_summary[["rank"]]

  # LP
  info_lp <<- ranked_summary[["LP"]]

  # Most played champion
  info_most_played_champion <<- champion_summary %>%
    group_by(name) %>%
    summarize(freq = sum(freq)) %>%
    filter(freq == max(freq)) %>%
    select(name) %>%
    mutate(name = as.character(name)) %>%
    pull()

  # Somewhere the freq multiplies by 2
  champion_summary <<- champion_summary %>%
    mutate(freq = freq / 2)

  # Return List
  summary_list <- c(info_account_name,
                    info_rank,
                    info_lp,
                    info_winrate,
                    info_most_played_champion)

  return(summary_list)
}