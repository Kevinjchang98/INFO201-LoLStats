ui <- material_page(title = "LoL Stats",
                    fluid = TRUE,
                    primary_theme_color = "rgba(56, 119, 175, 1)",
                    secondary_theme_color = "rgba(56, 119, 175, 1)",
   material_side_nav(
     fixed = FALSE,
     fluidRow(
       column(
         12, align = "center",
         h4("UW INFO 201 Final")
       )
     ),
     fluidRow(
       column(1),
       column(
         10,
         p("Created by Kevin Chang for the final project of INFO 201
           with Prof. T. Winegarden. Built with R and Shiny with plots in
           Plotly.
           Layout uses shinymaterial, found ",
           a("here",
             href = "https://ericrayanderson.github.io/shinymaterial/")),

       ),
       column(1)
     )
   ),
   material_tabs(
     tabs = c("Account" = "account",
              "Detailed Statistics" = "tableStats",
              "Champions" = "champGraph",
              "Time" = "timeGraph",
              "Win/Loss" = "winLossGraph",
              "Trends" = "timeStatsGraph",
              "Summary" = "summary")
   ),

   material_tab_content(tab_id = "account",
            column(1),

            column(
              3, align = "center", div(style = "height:20px"),
              fluidRow(
                h5("Account Info"),
                material_text_box(
                  input_id = "accountName",
                  label = "Account Name"),
              ),

              fluidRow(
                material_dropdown("region",
                                  "Region",
                                  choices =
                                     c("NA" = "na1",
                                       "EUW" = "euw1",
                                       "KR" = "kr")
                ),
              ),

             fluidRow(
                material_slider(
                   input_id = "numGames",
                   label = "Number of Matches to Query:",
                   min_value = 5,
                   max_value = 100,
                   initial_value = 50,
                   step_size = 1
                ),
             ),

             fluidRow(
                actionButton(
                  inputId = "submit_loc",
                  label = "Get stats")
             ),
            ),

            column(
              7, align = "center", div(style = "height:20px"),

              conditionalPanel(
                 condition = ("input.submit_loc == 0"),

                 column(1),
                 column(10,
                    h5("Introduction"),

                    p("This final project for INFO 201 allows players to
                      enter their player name and receive statistics from
                      their recent games. One can request up to 100 recent
                      games, and receive detailed numbers split into the
                      games won and lost for each champion, a graph of
                      which champions they've played recently and their
                      winrates, when they've played their games throughout
                      the day, comparison of a few key statistics between
                      games lost and won, as well as investigate various
                      trends in factors such as CS, or damage dealt over
                      time in their recent games played."),

                    p("All data comes from the Riot API, and is all
                      player-specific. Widgets to the left allow you
                      to filter all information by account, as well as
                      how many matches to be considered."),

                    p("Enter your information to the left and click
                      get stats to get started. Or for some example
                      data, try \"Dyrus\", or \"BoxBox\"")
                 ),
                 column(1)
              ),

              conditionalPanel(
                 condition = ("input.submit_loc == 1"),
                column(
                  12, align = "center",
                  h5("Basic Stats"),
                  fluidRow(
                    league <- textOutput(outputId = "league"),
                    uiOutput(outputId = "leagueImage"),
                    textOutput(outputId = "basicInfo")
                  )
                ),
              ),
              fluidRow(
                column(4,
                       plotlyOutput(outputId = "graphRolePie")
                ),
                column(4,
                       plotlyOutput(outputId = "graphWinratePie")
                ),
                column(4,
                       plotlyOutput(outputId = "graphKDAPie")
                ),

              ),
            ),
            column(1),

   ),

   material_tab_content(tab_id = "tableStats",
            fluidRow(
              column(6, align = "center", div(style = "height:20px"),
                     selectInput("championSelect",
                                 "Champion:",
                                 c("All",
                                   unique(as.character(
                                      champion_constants$name))))
              ),
              column(6, align = "center", div(style = "height:20px"),
                     selectInput("winLossSelect",
                                 "Win/Loss:",
                                 c("All",
                                   "Win",
                                   "Loss"))
              )
            ),
            fluidRow(
               column(1),
               column(10, align = "center", div(style = "height:20px"),
                      DT::dataTableOutput("tableChampion")
                      ),
               column(1)
            ),

            fluidRow(
               column(1),
               column(10,
                  h4("INFO 201 Information"),
                  p("This table provides insight for anyone wanting
                    to know very specific values, or sort by specific
                    values. For example, if one wants to see quickly
                    what their best champion in terms of average CS
                    was in all the games they won recently, or if
                    one wants to see the champion with the worst
                    KDA in games they lost, this table provides a
                    very easy way to sort and get a list. For this
                    sort of data analysis, a table was chosen as
                    being more effective than a graph, as the purpose
                    is to allow one to get a ranking in terms of
                    various factors.")
               ),
               column(1)
            )
   ),

   material_tab_content(tab_id = "champGraph",
            column(12, div(style = "height:20px"),
                   plotlyOutput(outputId = "graphChampion")
            ),

            fluidRow(
               column(1),
               column(10,
                      h4("INFO 201 Information"),
                      p("A bar chart further split into
                        win/loss by color allows players to see
                        various information about the champions
                        they played recently. One can see how
                        many different champions they played
                        with the number of elements on the x-axis,
                        as well as which are more popular than
                        others with their values on the y-axis.
                        One can also get a quick overview at
                        which champions may be more effective,
                        as they can see the rough winrates with
                        the colored splitting of the bar graph."),
                      
                      p("Amount of games to be included can be filtered
                  from the Account tab's slider and button, though
                  this requires one to wait a few seconds, as this
                  pulls from the API to update the data again.")
               ),
               column(1)
            )
   ),

   material_tab_content(tab_id = "timeGraph",
            column(12, div(style = "height:20px"),
                   plotlyOutput(outputId = "graphTime")
            ),

            fluidRow(
               column(1),
               column(10,
                      h4("INFO 201 Information"),
                      p("A bar graph similar to the champions
                        tab was chosen for similar reasons. As the
                        data is binned by hour start, a line graph
                        is not appropriate, and the splitting of the
                        bar graph into win and loss allows for
                        analysis of whether there's an optimal
                        time to play for the specific player."),
                      
                      p("Amount of games to be included can be filtered
                  from the Account tab's slider and button, though
                  this requires one to wait a few seconds, as this
                  pulls from the API to update the data again.")
               ),
               column(1)
            )
   ),

   material_tab_content(tab_id = "winLossGraph",
      fluidPage(
         column(
            3, align = "center", div(style = "height:20px"),
            plotlyOutput(outputId = "graphWinKDA")
         ),
         column(
            3, align = "center", div(style = "height:20px"),
            plotlyOutput(outputId = "graphWinDmg")
         ),
         column(
            3, align = "center", div(style = "height:20px"),
            plotlyOutput(outputId = "graphWinGold")
         ),
         column(
            3, align = "center", div(style = "height:20px"),
            plotlyOutput(outputId = "graphWinCS")
         ),
      ),

      fluidRow(
         column(1),
         column(10,
                h4("INFO 201 Information"),
                p("Four key statistics are averaged over
                  the games lost and won, and compared. This
                  allows for investigating which factors may
                  possibly be a cause for winning or losing.
                  Possible conclusions are elaborated upon
                  further in the summary section."),
                
                p("Amount of games to be included can be filtered
                  from the Account tab's slider and button, though
                  this requires one to wait a few seconds, as this
                  pulls from the API to update the data again.")
         ),
         column(1)
      )
   ),

   material_tab_content(tab_id = "timeStatsGraph",
      fluidPage(
         fluidRow(
            column(6, align = "center", div(style = "height:20px"),
                   selectInput(
                      "timeGraphXData", "Choose an x variable",
                      choices = c(
                         "Game Number" = "gameNum",
                         "Date" = "date"
                      )
                   ),

            ),
            column(6, align = "center", div(style = "height:20px"),
                   selectInput(
                      "timeGraphYData", "Choose a variable",
                      choices = c(
                         "Kills" = "kills",
                         "Deaths" = "deaths",
                         "Assists" = "assists",
                         "Total Damage" = "totalDamageDealt",
                         "Magic Damage" = "magicDamageDealt",
                         "Physical Damage" = "physicalDamageDealt",
                         "True Damage" = "trueDamageDealt",
                         "Champion Damage" = "totalDamageDealtToChampions",
                         "Objective Damage" = "damageDealtToObjectives",
                         "Tower Damage" = "damageDealtToTurrets",
                         "Damage Taken" = "totalDamageTaken",
                         "Gold Earned" = "goldEarned",
                         "Tower Kills" = "turretKills",
                         "CS" = "totalCreepScore",
                         "Vision Score" = "visionScore"
                      )
                   ),

            ),
         ),

         fluidRow(
            column(1),
            column(10,  div(style = "height:90%"),
                   plotlyOutput(outputId = "graphTimeStats")
            ),
            column(1)
         )
      ),
      fluidRow(
         column(1),
         column(10,
                h4("INFO 201 Information"),
                p("Here, a scatter plot was chosen to allow for
                  analysis of any patterns over time. With a linear
                  plotting of game number and a loess curve fit, one
                  can quickly see if there appears to be any trends
                  in a variety of variables that can be plotted on
                  the y-axis. One may also choose to plot the games
                  by their date, which may be more appropriate for
                  players that may have large gaps in play time, as
                  that also allows them to analyze any overarching
                  patterns in their clusters of games as opposed to
                  the linear plotting with game number.")
         ),
         column(1)
      )
   ),

   material_tab_content(tab_id = "summary",
      column(1),
      column(10,
          h3("Main Takeaways - INFO 201"),

          p("It is generally pretty hard to be able to generalize
            statistics that appear consisitent amongst the entire
            playerbase of League of Legends without doing a more meta
            analysis. Thus, some example takeaways for specific sets
            of data from public figures are provided below."),

          h4("Specific Data"),

          h5("Dyrus Player Statistics"),

          p("As of June 6, 2020, looking at the most recent 50 games
            played, it appears that Dyrus is a relatively high-ranked
            Top-lane player. He's got a relatively high winrate of 60%,
            and plays a very narrow set of characters consistently
            (basically only Tryndamere), though he's played a variety
            of champions at least once. He mostly plays in the evening,
            with no hour of the day having an unusual winrate. His Average
            KDA as calculated on the Win/Loss tab has a large difference
            between games lost and won. The average total damage dealt as
            well as average CS is slightly higher in the games he lost than
            won, likely due to the games he ended up losing consisting of
            Dyrus being at a disadvantageous position and being more unable
            to end the game. Thus, these longer games would lead to higher
            total damage and higher CS in contrast to games where he may have
            gotten an early lead, and thus was able to win relatively quickly.
            Average gold obtained appears to be roughly the same in between
            lost and won games."),

          h5("BoxBox Player Statistics"),

          p("As of June 6, 2020, looking at the most recent 50 games
            played, BoxBox's stats should be comparable to Dyrus as
            they're both relatively high-ranked Top-lane players. BoxBox
            has a slightly negative winrate at 44%, and has played a
            much narrower set of champions. However, he's played an
            almost equal amount of Fiora and Riven, as opposed to only
            Tryndamere with Dyrus. He also has a single Gaussian
            distribution for time of game start, centered around 2:00 to
            3:00 AM, as opposed to Dyrus having some more outlier games
            throughout the day. The stats in the Win/Loss tab is
            relatively consistent, with KDA having a large disparity
            between lost and won games, and the rest three being roughly
            equal when taking into account random statistical error. More
            in-depth analysis of BoxBox was performed in the Midpoint
            Deliverable."),

          h4("Notable Data-Insights or Patterns"),

          p("While looking at Dyrus and BoxBox's data, several possible
            common trends may be gathered, though further, more thorough
            analysis should be performed to be able to actually support
            or disprove these."),

          h5("Win/Loss Trends"),

          p("It appears that KDA is the largest factor that was analyzed
            that varies between games won and lost. This makes intuitive
            sense for players at a higher level, as gameplay elements
            against the computer such as amount of CS gained while in
            lane shouldn't vary as much as the human to human interactions
            between enemy laners. Furthermore, higher level players should
            be able to capitalize on any early kills or deaths, converting
            the single kill or death into an advantage which would lead
            to more kills or deaths, and thus winning or losing the game.
            This suggests that the largest gap between skill ceiling
            and player skill may be in player to player interactions,
            rather than factors such as being able to get perfect or
            near-perfect CS for higher level players. This is further
            supported by CS and gold earned being relatively consistent
            between games won and lost."),
          h5("Time of Day Trends"),

          p("It appears that there is no significant correlation between
            time of game start and game performance, though this is a
            very loose conclusion based upon very few data points (players).
            This is also a very personal stat, and so one expects
            that for some players, there may be a time of day that
            is optimal, and provides a significantly better winrate
            than other times of day."),
          h4("Broader Implications"),

          h5("Importance of Human Elements"),
          p("With the statistics provided in the Win/Loss area, this
            may suggest that more \"human\" elements may be playing
            a larger deciding factor in how games go rather than other
            factors. i.e., In contrast to sports such as university-level
            Formula SAE, where, arguably, engineering of the vehicle
            plays a large deciding factor in who wins or loses rather
            than the individual decisions and skills of the driver,
            League of Legends appears to have players' decision-making
            and interactions with the enemy team be a larger deciding
            factor in game outcome, at least in higher levels."),

          p("It is also suggested that lower-level players have the
            opposite problem, where losing CS, which is an action the
            player takes against the computer rather than the enemy
            players directly, may be a larger factor in whether they
            win or lose games. This may be apparent in Win/Loss trends
            if, for example, the average CS in games lost would be
            much lower than in the games won, suggesting a possible
            causational relationship. Further meta-analysis across
            players would be needed to draw any strong conclusions,
            however."),

          p("Thus, one may draw a parallel between League of Legends
            and sports such as Olympic fencing, tennis, etc., where
            player to player interactions and decision making may
            make more of an impact rather than pure refinement of
            mechanics, since, at the highest level, everyone has
            arguably near-perfect technique. And similarly with
            LoL and sports such as fencing or tennis, at lower
            levels, it may benefit players more to focus more on
            the basics such as CS in League or footwork in fencing
            rather than higher-level decision making and mind-games."),

          h5("Narrow Champion/Role Selection"),

          p("As exhibited with Dyrus and BoxBox's Champions and
            Role Summary information, it appears that they both
            play a relatively narrow set of champions, with Dyrus
            recently focusing on Tryndamere and BoxBox on Riven
            and Fiora out of the 100+ available champions. This
            suggests that it may benefit players looking to reach
            higher levels of play to try and focus on a singular
            role, and perhaps a narrow subset of the champions fit
            for that role depending on current metagame status.")
       ),
      column(1)
   ),
)