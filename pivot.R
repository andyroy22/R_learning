library(data.table)

# pivot table
# dt: data.table
# cn: column names to pivot by
# fn: file name to save (or NULL)
make_pivot_table <- function(dt,cn,fn=NULL) {
  if (class(dt)[1] != 'data.table') {
    message('data.table required')
    return()
  }
  calc_pct<-function(x) { round(100*x$Count/x$Count[nrow(x)],1) }
  
  if (any(grepl('Count',colnames(dt))))
    dtPivot <- cube(dt, list(Count=sum(Count)), by=cn)
  else
    dtPivot <- cube(dt, list(Count=.N), by=cn)

  dtPivot[, cbind(.SD, Pct=calc_pct(.SD)), eval(cn[-length(cn)])] -> p1
  if (!is.null(fn))
    write.csv(p1,fn,row.names=F)
  return(p1)
}

# read file & prepare
fn <- '~/Downloads/mydata.txt'
dt <- fread(fn,sep="|",colClasses=strrep("c",200),quote='')
setnames(dt,c('number_of_children_in_living_unit'),c('num_child')) # change colnames

# create a grouping of values
marital <- list(
  married=c("5M","1M"),
  single =c("5S"),
  unknown=c("0U","","5U"))
# translate values to group indicator
dt$marital <- names(sapply(dt$maritalstatus,function(y) 
                    which(sapply(marital,function(x) any(y==x))),USE.NAMES=F))
