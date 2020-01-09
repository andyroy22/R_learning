#
# Basketball Statistics - basketball.R
#
# Retrieve stats from basketball-reference.com and uncover patterns
#
library(data.table)
library(ballr)

# retrieve player data
# examples (first try it on web then copy the url here)

bb <- NBAPlayerPerGameStats('/players/c/curryst01/shooting/2019')
bb[6:8,1:10]
bb$fg[7:8]

bb <- NBAPlayerPerGameStats('/players/c/curryst01/splits/2019')
bb$totals_4[2]


# retrieve team data
bb2 <- as.data.table( NBASeasonTeamByYear("UTA","2019") )
bb2[opponent=='Toronto Raptors',.(tm,opp)]
bb2[tm>125,.(opponent,tm,opp,x_4)]

# game statistics
bb <- as.data.table( NBAPerGameStatistics(season = 2018) )
nrow(bb)
bb[tm=='ATL',1:10]
bb[,.N,tm]

