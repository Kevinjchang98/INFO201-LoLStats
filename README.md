# Links
Link to midpoint deliverable: https://info-201a-sp20.github.io/final-project-Kevinjchang98/

Link to final Shiny App: https://kevinjchang98.shinyapps.io/final-project-Kevinjchang98/

# Project Setup
I'm the only person, but if I were to have group mates I'd go to settings on the repo page, then manage access, then invite a collaborator.

# Domain of Interest

## Main topic
I'll try to do some data analysis on video games / eSports. I'll probably do League of Legends because of it having an established professional scene as well as it having an open API with a wide variety of data.

## Why?
I've played LoL in the past, and would also like to explore using APIs more, so this seems like a reasonable choice. Machine Learning might also be fun to investigate if I end up having enough time. I planned on doing this sort of project over this summer, so starting in R in this class would be fun.

## Existing Related Examples

<!-- TODO: Look at rubric -->

### [What is it like to be a Data Scientist with a passion for Gaming ...](https://towardsdatascience.com/what-is-like-to-be-a-data-scientist-with-a-passion-for-gaming-43c067ad6415)

This is an example of an article someone on Medium wrote about their personal project in analyzing some aspects of professional LoL. Their main aim appeared to be to see if one can use statistics from the past to predict if one team will win or not in a game.

Their final results appeared to have an accuracy of 98.43% in predicting if one team will win or lose, however they used statistics that would happen during the game itself, and admitted that only using prematch knowledge would be a very weak predictor of match outcome.

They made a Shiny app, though it appeared to not be linked in the article.

### [Understanding League of Legends Data Analytics](https://medium.com/snipe-gg/understanding-league-of-legends-data-analytics-c2e5d77b55e6)

This was a more meta-study on analytic websites that provide data and stats for players. It points out some advantages and pitfalls of such sites, and emphasizes the importance of stats in creating a particular 'metagame' for video games due to their availability for the average person.

### [OP.GG](https://na.op.gg/)

This is an example of one of the data sites mentioned in the second example. Here, a player can enter their username and receive statistics based on their recent past games, for example the stats for the [ex-professional Dyrus](https://na.op.gg/summoner/userName=Dyrus).

### [Machine Learning to analyze League of Legends](https://business.blogthinkbig.com/machine-learning-to-analyze-league-of/)

Another example of machine learning being used to attempt to predict match outcomes for various teams. They used unsupervised and supervised learning for categorization of teams, and prediction of future match outcomes, respectively. They also chose to use team data rather than individual player data. In the end, they used their model to make predictions for the first three rounds of group stage games at a then-ongoing tournament, with the most accurate model having  68.75% accuracy, which was higher than they had originally expected.

### [Actions](https://actions.quarte-riposte.com/)

An example of using ML and webscraping of the FIE database for fencing referees to train or comment upon what certain actions are. May be relevant in comparisons to projects on conventional sports.

## What questions?

1. How impactful are pre-match decisions in affecting the outcome of the match itself compared to factors that occur during the game?
2. Are there overall trends that appear to be similar to other eSports? Are there trends that appear to be unique to LoL or this genre of competitive video games? What parallels are there to "real" sports such as baseball or fencing?
3. How do various factors such as variance in champion choice affect a player's improvement? Does improvement tend to follow some sort of piecewise-linear trend, or other model?

# Data Sets

## [Riot API's Player Data](https://developer.riotgames.com/apis#match-v4)

This is from the official Riot API, and is generated for each individual player. This is the most recent 100 games for any player. The data includes data such as champion played, lane/role, etc.

For a valid player, you get 8 columns of 100 rows of recent match data.

This would allow for analysis of any recent trends pertaining to a particular player. Relevent trends could be roles played, champions played, and win/loss trends, as well as match ID's for each match which lets one investigate a particular match in more detail.

## [Riot API's Match Data](https://developer.riotgames.com/apis#match-v4/GET_getMatch)

This is from the official Riot API, generated for each individual match. This gives detailed information about a specific match in detail. For example, number of towers killed, the people that played in this match, who won, etc.

Here, you get 11 main columns of data to be analyzed, which have values by each frame of game time. Children data include data such as someone using a spell, destroying a building, leveling up, buying an item, etc. The number of rows depends upon the game, as games are of different length and thus have different frames. But, for example, as of writing this, Dyrus' most recent match had 2340647 frames of data, so that table would have 23406470 rows of data to be analyzed, as each frame appears to be split into 10 frames.

Any particular insights that are based upon the events in a match can be gained from examining this data set. For example, trends such as those relating to objectives destroyed and its correlation to winning or losing a game, or various habits that may be present at higher skill levels compared to at lower skill levels (could be done by comparing trends of games from players of various ranks)

## [OpenDota API](https://docs.opendota.com/)

An unofficial API for DotA 2, a video game / eSport in the same genre as LoL.

Various sets of data could be obtained from this API, as an example for analysis, one can request data on a particular pro player, and would get 21 columns with 1 row of data, including but not limited to when they last logged in, their team, and country. Or one can get information about public matches, which would give 7 columns with 1 row of data, including but not limited to who won, how long the game was, and when it was played.

May be interesting to compare overarching themes, perhaps in the professional level for any common or uncommon trends.

## [International Fencing Federation Results](https://fie.org/competitions)

This is a website with information on international fencing competitions. Could be scraped to produce a usable database.

<!-- https://www.reddit.com/r/Fencing/comments/bogvnb/machine_learningsports_analysis/ -->

This does not produce a JSON as with the above data sets, and instead gives the direct elmination tableaus and the scores, as well as the final ranking for a particular event. Information for each athlete includes their name, scores in each bout, and the country/team they represented. Higher level data about the event is also included, with the name of the event, date, weapon, gender, age category, and type (e.g., team event).

May be interesting to compare eSports to conventional sports, of which I best understand fencing. Could also look for some team sports to compare data to if I decide to do more analysis for comparing eSports to conventional sports.
