# Get updated information about champions
champion_constants <<- get_champion_constants() %>%
  ldply(data.frame)

champion_constants[, "key"] <-
  as.numeric(as.character(champion_constants[, "key"]))

champion_constants <<-
  champion_constants[!duplicated(champion_constants$key), ]