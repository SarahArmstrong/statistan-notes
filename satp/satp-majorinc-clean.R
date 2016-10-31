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
  datlist[[i]] <- datlist[[i]][-nrow(datlist[[i]]),] # Drop last, totaled row
}

df2013_2016 <- rbind.fill(datlist)
rm(list = ls(pattern = 'dat')) # Remove objects with dat or yrs in name

# Split Date -> "Month", "Day" columns

date <- data.frame(do.call('rbind', strsplit(as.character(df2013_2016$Date),' ', fixed = TRUE)))
names(date) <- c('Month', 'Day')
date$Month <- match(date$Month, month.name)
df2013_2016 <- cbind(df2013_2016, date)
rm(date)

# Extract location (district and province) information from 'Incidents' column:

distr <- read.csv('districts.csv')
prov <- read.csv('provinces.csv')
dat_loc <- merge(x = distr, y = prov, by.x = 'Province.id', by.y = 'id')
colnames(dat_loc)[2] <- 'District.id'
colnames(dat_loc)[7] <- 'Province.Name'
dat_loc <- dat_loc[, c(1, 2, 3, 7)]

dat_loc$District.Name <- as.character(dat_loc$District.Name)
dat_loc$Province.Name <- as.character(dat_loc$Province.Name)

# Force 'Incidents' as string and append District and
df2013_2016$Incidents <- as.character(df2013_2016$Incidents)
df2013_2016$District <- NA
df2013_2016$Province <- NA

df2013_2016 = rename(df2013_2016, c('C.Killed' = 'Civilians_killed'))
df2013_2016 = rename(df2013_2016, c('SFs.Killed' = 'SecForces_killed'))
df2013_2016 = rename(df2013_2016, c('T.Killed' = 'Terrorists_kiled'))
df2013_2016 = rename(df2013_2016, c('Total.Killed' = 'Total_killed'))

# Fill District column using fuzzy matching:

dat <- df2013_2016

for(i in 1:nrow(dat)) {
  for(l in 1:nrow(dat_loc)) {
    if (grepl(dat_loc$District.Name[l], dat$Incidents[i])) {
      dat$District[i] <- dat_loc$District.Name[l]
    } else if ((is.na(dat$District[i])) & (agrepl(dat_loc$District.Name[l], dat$Incidents[i]))) {
      dat$District[i] <- dat_loc$District.Name[l]
    } else {
      dat$District[i]
    }
  }
  if (is.na(dat$District[i])) {
    ifelse(agrepl('Bolan', dat$Incidents[i]), dat$District[i] <- 'Kachhi', dat$District[i])
    ifelse(agrepl('SWA', dat$Incidents[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
    ifelse(agrepl('Wana', dat$Incidents[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
    ifelse(agrepl('Turbat', dat$Incidents[i]), dat$District[i] <- 'Kech', dat$District[i])
    ifelse(agrepl('Sui', dat$Incidents[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
    ifelse(agrepl('Somyani', dat$Incidents[i]), dat$District[i] <- 'Lasbela', dat$District[i])
    ifelse(agrepl('Mingora', dat$Incidents[i]), dat$District[i] <- 'Swat', dat$District[i])
    ifelse(agrepl('Dera Murad Jamali', dat$Incidents[i]), dat$District[i] <- 'Nasirabad', dat$District[i])
    ifelse(agrepl('Mach', dat$Incidents[i]), dat$District[i] <- 'Kachhi', dat$District[i])
    ifelse(agrepl('Chaman', dat$Incidents[i]), dat$District[i] <- 'Killa Abdullah', dat$District[i])
    ifelse(agrepl('Saraib', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Dhadar', dat$Incidents[i]), dat$District[i] <- 'Kachhi', dat$District[i])
    ifelse(agrepl('Rakhni', dat$Incidents[i]), dat$District[i] <- 'Barkhan', dat$District[i])
    ifelse(agrepl('Muridke', dat$Incidents[i]), dat$District[i] <- 'Sheikhupura', dat$District[i])
    ifelse(agrepl('Magsi', dat$Incidents[i]), dat$District[i] <- 'Jhal Magsi', dat$District[i])
    ifelse(agrepl('Shakai', dat$Incidents[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
    ifelse(agrepl('Ahmadwal', dat$Incidents[i]), dat$District[i] <- 'Chaghai', dat$District[i])
    ifelse(agrepl('Kandhkot', dat$Incidents[i]), dat$District[i] <- 'Kashmore', dat$District[i])
    ifelse(agrepl('Dera Allah Yar', dat$Incidents[i]), dat$District[i] <- 'Jafarabad', dat$District[i])
    ifelse(agrepl('Kahan', dat$Incidents[i]), dat$District[i] <- 'Kohlu', dat$District[i])
    ifelse(agrepl('Baidara', dat$Incidents[i]), dat$District[i] <- 'Swat', dat$District[i])
    ifelse(agrepl('Aiman Abad', dat$Incidents[i]), dat$District[i] <- 'Gujranwala', dat$District[i])
    ifelse(agrepl('Miranshah', dat$Incidents[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
    ifelse(agrepl('Paharpur', dat$Incidents[i]), dat$District[i] <- 'Dera Ismail Khan', dat$District[i])
    ifelse(agrepl('Kolpur', dat$Incidents[i]), dat$District[i] <- 'Mastung', dat$District[i])
    ifelse(agrepl('Bajaur', dat$Incidents[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
    ifelse(agrepl('Pasni', dat$Incidents[i]), dat$District[i] <- 'Gwadar', dat$District[i])
    ifelse(agrepl('Killi Omar', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Green Town', dat$Incidents[i]), dat$District[i] <- 'Lahore', dat$District[i])
    ifelse(agrepl('Khyber', dat$Incidents[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
    ifelse(agrepl('Hub', dat$Incidents[i]), dat$District[i] <- 'Lasbela', dat$District[i])
    ifelse(agrepl('Kurram', dat$Incidents[i]), dat$District[i] <- 'Kurram Agency', dat$District[i])
    ifelse(agrepl('Mamond', dat$Incidents[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
    ifelse(agrepl('Wadh', dat$Incidents[i]), dat$District[i] <- 'Khuzdar', dat$District[i])
    ifelse(agrepl('Dangeen', dat$Incidents[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
    ifelse(agrepl('Gosh', dat$Incidents[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
    ifelse(agrepl('Dosli', dat$Incidents[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
    ifelse(agrepl('Nawagai', dat$Incidents[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
    ifelse(agrepl('Dir', dat$Incidents[i]), dat$District[i] <- 'Upper Dir', dat$District[i])
    ifelse(agrepl('Landi Kotal', dat$Incidents[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
    ifelse(agrepl('Bostan', dat$Incidents[i]), dat$District[i] <- 'Pishin', dat$District[i])
    ifelse(agrepl('Bhojpur', dat$Incidents[i]), dat$District[i] <- 'Gujrat', dat$District[i])
    ifelse(agrepl('Saddar', dat$Incidents[i]), dat$District[i] <- 'Rawalpindi', dat$District[i])
    ifelse(agrepl('Askari', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Akhtarabad', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Parkaniabad', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Parkaniabad', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Gandoi', dat$Incidents[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
    ifelse(agrepl('Sariab', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Sakran Road', dat$Incidents[i]), dat$District[i] <- 'Lasbela', dat$District[i])
    ifelse(agrepl('Pash Bogi', dat$Incidents[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
    ifelse(agrepl('Lakpass', dat$Incidents[i]), dat$District[i] <- 'Mastung', dat$District[i])
    ifelse(agrepl('Tausa', dat$Incidents[i]), dat$District[i] <- 'Dera Ghazi Khan', dat$District[i])
    ifelse(agrepl('Matta', dat$Incidents[i]), dat$District[i] <- 'Swat', dat$District[i])
    ifelse(agrepl('Kajla Mor', dat$Incidents[i]), dat$District[i] <- 'Nasirabad', dat$District[i])
    ifelse(agrepl('Bara', dat$Incidents[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
    ifelse(agrepl('Mand', dat$Incidents[i]), dat$District[i] <- 'Kech', dat$District[i])
    ifelse(agrepl('Manikhel', dat$Incidents[i]), dat$District[i] <- 'Mardan', dat$District[i])
    ifelse(agrepl('Naway Qamar', dat$Incidents[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
    ifelse(agrepl('Loti', dat$Incidents[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
    ifelse(agrepl('Mawind', dat$Incidents[i]), dat$District[i] <- 'Kohlu', dat$District[i])
    ifelse(agrepl('Khar', dat$Incidents[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
    ifelse(agrepl('Inayet Kali', dat$Incidents[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
    ifelse(agrepl('Bilitang', dat$Incidents[i]), dat$District[i] <- 'Kohat', dat$District[i])
    ifelse(agrepl('Samungli', dat$Incidents[i]), dat$District[i] <- 'Quetta', dat$District[i])
    ifelse(agrepl('Kabal', dat$Incidents[i]), dat$District[i] <- 'Swat', dat$District[i])
  } else {
    dat$District[i]
  }
}

missing_distr <- dat[is.na(dat$District),]
nrow(missing_distr)

# Fill Province column using fuzzy matching:
for (i in 1:nrow(dat)) {
  for (l in 1:nrow(dat_loc)){
    if (grepl(dat_loc$District.Name[l], dat$District[i])) {
      dat$Province[i] <- dat_loc$Province.Name[l]
    } else if ((is.na(dat$Province[i])) & (grepl(dat_loc$Province.Name[l], dat$Incidents[i]))) {
      dat$Province[i] <- dat_loc$Province.Name[l]
    } else if ((is.na(dat$Province[i])) & (agrepl(dat_loc$Province.Name[l], dat$Incidents[i]))) {
      dat$Province[i] <- dat_loc$Province.Name[l]
    } else {
      dat$Province[i]
    }
  }
  if (is.na(dat$Province[i])) {
    ifelse(grepl('AJK', dat$Incidents[i]), dat$Province[i] <- 'Azad Kashmir', dat$Province[i])
    ifelse(grepl('BL', dat$Incidents[i]), dat$Province[i] <- 'Balochistan', dat$Province[i])
    ifelse(grepl('Federally Administered Tribal Areas', dat$Incidents[i]), dat$Province[i] <- 'FATA', dat$Province[i])
    ifelse(grepl('GB', dat$Incidents[i]), dat$Province[i] <- 'Gilgit Baltistan', dat$Province[i])
    ifelse(grepl('ICT', dat$Incidents[i]), dat$Province[i] <- 'Islamabad', dat$Province[i])
    ifelse(grepl('JK', dat$Incidents[i]), dat$Province[i] <- 'Jammu and Kashmir', dat$Province[i])
    ifelse(grepl('KP', dat$Incidents[i]), dat$Province[i] <- 'Khyber Pakhtunkhwa', dat$Province[i])
    ifelse(grepl('NWFP', dat$Incidents[i]), dat$Province[i] <- 'Khyber Pakhtunkhwa', dat$Province[i])
    ifelse(grepl('N.W.F.P.', dat$Incidents[i]), dat$Province[i] <- 'Khyber Pakhtunkhwa', dat$Province[i])
    ifelse(grepl('PJ', dat$Incidents[i]), dat$Province[i] <- 'Punjab', dat$Province[i])
    ifelse(grepl('SN', dat$Incidents[i]), dat$Province[i] <- 'Sindh', dat$Province[i])
  } else {
    dat$Province[i]
  }
}

missing_prov <- dat[is.na(dat$Province),]
nrow(missing_prov)


# Merge all years together

# XXXXXXX

# Force NAs as empty strings for back end of tool
#dat <- sapply(dat, as.character)
#dat[is.na(dat)] <- ""

# Export dat as .csv file
#write.csv(dat, 'bbdata.csv', row.names = FALSE)