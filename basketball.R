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
bb2 <- as.data.table( NBASeasonTeamByYear("CHI","2019") )
bb2$date <- as.Date(bb2$date,format='%A, %B %d, %Y') # convert text date to 'Date' object

bb2[opponent=='Toronto Raptors',.(tm,opp)]
bb2[tm>125,.(opponent,tm,opp,x_4)]

table(bb2$x_4) # Win/Loss counts
prop.table(table(bb2$x_4)) # Win/Loss proportion (ratio)
round(prop.table(table(bb2$x_4))*100,1) # Win/Loss percentage - multiply by 100, round to 1 decimal

# per game statistics
## read per game stats and store in a data.table
## data.tables have some convenient notation for accessing
bb3 <- as.data.table( NBAPerGameStatistics(season = 2018) )

nrow(bb3) # number of rows in the data table
colnames(bb3) # list column names for this table

# bb3[tm=='ATL',] # return rows where 'tm' equals 'ATL', show all columns
bb3[tm=='ATL',1:10] # return rows where 'tm' equals 'ATL', show only the first 10 columns
bb3[tm=='ATL',.(player,tm,fg,pts)] # return rows where 'tm' equals 'ATL', show specified columns

bb3[,.N,tm] # group all rows by 'tm' and show how many per group - .N is a special symbol

#
# graph the data
#
library(ggplot2)

city <- 'ATL'
dat <- bb3[tm==city,.(player,tm,fg,pts)][order(fg),]

ggplot() + geom_bar(data=dat,aes(x=reorder(player,-fg),y=fg),stat="identity") +
   theme(axis.text.x=element_text(angle=60,hjust=1)) +
   labs(x="",y="") + ggtitle(paste0("field goals - ",city))


#
# very crude example of basic plot in R
# Arrows pointing from opponent's score to team's score
#
# first extract the team (tm) and opponent scores, these are the 'y values'
# set the 'x values' to the date (same for both ends of the arrow)
#

dat <- bb2[,.(x1=date,y1=opp,x2=date,y2=tm,win=x_4)]
dat <- dat[1:25,]
# this is similar to dat[,.(a,b,c,d)]
# but we are giving 'names' to the values, x1,y1, x2,y2
plot(dat$x1,dat$y1)
points(dat$x2,dat$y2,col='blue',pch=20)
arrows(dat$x1,dat$y1,dat$x2,dat$y2,col='red')

# here is the same plot using the advanced ggplot function
ggplot() + 
   geom_segment(data=dat, aes(x = x1, y = y1, xend = x2, yend = y2, col=win),
                     arrow = arrow(length=unit(5,"points")) )

## documentation ##

# ballr - author
# Ryan.Elmore@du.edu
# https://daniels.du.edu/directory/ryan-elmore/
# http://www.datacolorado.com/
# https://github.com/rtelmore/ballr

