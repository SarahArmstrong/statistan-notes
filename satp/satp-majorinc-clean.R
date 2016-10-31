setwd("C:/Users/user/Documents/Git/statistan-data/SATP/major incidents")
library(plyr)

# Load 1988 - 2006 .csv file and convert to separate data.frames by year

df <- read.csv("midata1988-2006")

yrs <- as.character(seq(1988, 2006, 1))

# Identify dat_ index values for corresponding years
yrs.df_index <- sapply(yrs, function(y) grep(y, df$X0))
yrs.df_index <- yrs.df_index[lapply(yrs.df_index, length) > 0] #Remove years for which no observations from years index list
yrs.df_index <- unlist(yrs.df_index)
yrs.df_index <- yrs.df_index[order(yrs.df_index)]
yrs.df_index <- as.list(yrs.df_index)

# Split dat_ list into sublists by year
splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))
df <- splitAt(df$X0, yrs.df_index)

# Define dat_ list elements as data.frames
for (i in 1:length(yrs.df_index)) {
  assign(paste0("dat", df[[i]][1]), data.frame(df[[i]]))  
}

datlist <- lapply(ls(pattern = 'dat'), get)

datlist_yrs <- as.numeric(names(yrs.df_index))
datlist_yrs <- datlist_yrs[order(datlist_yrs)]

for(i in 1:length(datlist)){
  vector <- rep(datlist_yrs[i], nrow(datlist[[i]]))
  datlist[[i]]$Year <- vector # Add year columns to data.frames
  datlist[[i]]<- datlist[[i]][-1,] # Drop first row (equal to year value)
}

# Merge datlist into dat1988_2006

df1988_2006 <- rbind.fill(datlist)
rm(list = ls(pattern = 'dat')) # Remove objects with dat or yrs in name
rm(list = ls(pattern = 'yrs'))

# Load 2007 - 2012 .csv files as data.frames

a <- 2007
b <- 2012
for(i in a:b){
  filename <- paste0("midata", i)
  assign(paste0("dat", i), read.csv(filename))
}

years <- seq(a, b, by = 1)

datlist <- lapply(ls(pattern = 'dat'), get)

for(i in 1:length(datlist)){
  vector <- rep(years[i], nrow(datlist[[i]]))
  datlist[[i]]$Year <- vector # Add year columns to data.frames
  datlist[[i]] <- datlist[[i]][,-1] # Drop index column
}


# Merge datlist into dat2007_2012

df2007_2012 <- rbind.fill(datlist)
rm(list = ls(pattern = 'dat')) # Remove objects with dat or yrs in name
rm(list = ls(pattern = 'yrs'))

# Merge df1988_2006 and df2007_2012 to df1988_2012

df1988_2006 = rename(df1988_2006, c('df..i..' = 'x'))
df2007_2012 = rename(df2007_2012, c('X0' = 'x'))

df1988_2012 <- rbind.fill(df1988_2006, df2007_2012)
rm(df1988_2006)
rm(df2007_2012)
rm(df)

# Parse df1988_2012:

# XXXXXX

# Load 2013 - 2016 .csv files as data.frames

a <- 2013
b <- 2016
for(i in a:b){
  filename <- paste0("midata", i)
  assign(paste0("dat", i), read.csv(filename))
}

# Add corresponding year value to each data.frame, drop Pandas index column, drop last (totaled) row:

years <- seq(a, b, by = 1)

datlist <- lapply(ls(pattern = 'dat'), get)

for(i in 1:length(datlist)){
  vector <- rep(years[i], nrow(datlist[[i]]))
  datlist[[i]]$Year <- vector # Add year columns to data.frames
  datlist[[i]] <- datlist[[i]][,-1] # Drop index column
}

df2013_2016 <- rbind.fill(datlist)
rm(list = ls(pattern = 'dat')) # Remove objects with dat or yrs in name

# Split Date -> "Month", "Day" columns

date <- data.frame(do.call('rbind', strsplit(as.character(df2013_2016$Date),' ', fixed = TRUE)))
names(date) <- c('Month', 'Day')
date$Month <- match(date$Month, month.name)
df2013_2016 <- cbind(df2013_2016, date)

