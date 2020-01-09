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

# per game statistics
## read per game stats and store in a data.table
## data.tables have some convenient notation for accessing
bb <- as.data.table( NBAPerGameStatistics(season = 2018) )

nrow(bb) # number of rows in the data table
colnames(bb) # list column names for this table

bb[tm=='ATL',] # return rows where 'tm' equals 'ATL', show all columns
bb[tm=='ATL',1:10] # return rows where 'tm' equals 'ATL', show only the first 10 columns
bb[tm=='ATL',.(player,tm,fg,pts)] # return rows where 'tm' equals 'ATL', show specified columns

bb[,.N,tm] # group all rows by 'tm' and show how many per group - .N is a special symbol

