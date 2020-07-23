format_summary_table <- function(champion_summary) {
  summary_table <- champion_summary %>%
    group_by(name) %>%
    select(name,
           winInt,
           freq,
           avgKDA,
           avgTotDmg,
           avgGoldEarned,
           avgCS) %>%
    mutate(freq = round(freq, 0),
           avgKDA = round(avgKDA, 2),
           avgTotDmg = round(avgTotDmg, 0),
           avgGoldEarned = round(avgGoldEarned, 0),
           avgCS = round(avgCS, 0),
           winInt = ifelse(
             winInt == 1,
             "Win",
             "Loss")
           ) %>%
    rename("Champion" = name,
           "Win/Loss" = winInt,
           "Games played" = freq,
           "Average KDA Ratio" = avgKDA,
           "Average Total Damage" = avgTotDmg,
           "Average Gold Earned" = avgGoldEarned,
           "Average CS" = avgCS)

  summary_table$Champion <- as.character(summary_table$Champion)

  return(summary_table)
}