setwd("C:/Users/user/Documents/Git/statistan-data/SATP/bomb blasts")
library(plyr)

# Load in all datasets by year
dat2000 <- read.csv("bbdata2000")

a <- 2001
b <- 2016

for(i in a:b){
  filename <- paste0("bbdata", i)
  assign(paste0("dat", i), read.csv(filename))
}

# Add corresponding year value to each data.frame, drop Pandas index column, drop last (totaled) row:

c <- 2000
years <- seq(c, b, by = 1)

dlist <- lapply(ls(pattern = 'dat'), get)
names(dlist) <- rep(NA, length(dlist))

for(i in 1:length(dlist)){
  dlist[[i]] <- dlist[[i]][,-1] # Drop index column
  dlist[[i]] <- dlist[[i]][-nrow(dlist[[i]]),] # Drop last, totaled row
  names(dlist)[i] <- toString(years[i])
  vector <- rep(as.numeric(names(dlist)[i]), nrow(dlist[[i]]))
  dlist[[i]]$Year <- vector # Add year columns to data.frames
}

dat <- rbind.fill(dlist)

distr <- read.csv('districts.csv')
distr$District.Name <- as.character(distr$District.Name)
districts <- distr$District.Name

prov <- read.csv('provinces.csv')
prov$Province <- as.character(prov$Province)
provinces <- prov$Province

# Force 'Place' as string and append District and
dat$Place <- as.character(dat$Place)
dat$District <- NA
dat$Province <- NA

# Fill District column using fuzzy matching (agrepl):
for(i in 1:nrow(dat)) {
  ifelse(agrepl('Bolan', dat$Place[i]), dat$District[i] <- 'Kachhi', dat$District[i])
  ifelse(agrepl('SWA', dat$Place[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
  ifelse(agrepl('Wana', dat$Place[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
  ifelse(agrepl('Turbat', dat$Place[i]), dat$District[i] <- 'Kech', dat$District[i])
  ifelse(agrepl('Sui', dat$Place[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
  ifelse(agrepl('Somyani', dat$Place[i]), dat$District[i] <- 'Lasbela', dat$District[i])
  ifelse(agrepl('Mingora', dat$Place[i]), dat$District[i] <- 'Swat', dat$District[i])
  ifelse(agrepl('Dera Murad Jamali', dat$Place[i]), dat$District[i] <- 'Nasirabad', dat$District[i])
  ifelse(agrepl('Mach', dat$Place[i]), dat$District[i] <- 'Kachhi', dat$District[i])
  ifelse(agrepl('Chaman', dat$Place[i]), dat$District[i] <- 'Killa Abdullah', dat$District[i])
  ifelse(agrepl('Saraib', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Dhadar', dat$Place[i]), dat$District[i] <- 'Kachhi', dat$District[i])
  ifelse(agrepl('Rakhni', dat$Place[i]), dat$District[i] <- 'Barkhan', dat$District[i])
  ifelse(agrepl('Muridke', dat$Place[i]), dat$District[i] <- 'Sheikhupura', dat$District[i])
  ifelse(agrepl('Magsi', dat$Place[i]), dat$District[i] <- 'Jhal Magsi', dat$District[i])
  ifelse(agrepl('Shakai', dat$Place[i]), dat$District[i] <- 'South Waziristan', dat$District[i])
  ifelse(agrepl('Ahmadwal', dat$Place[i]), dat$District[i] <- 'Chaghai', dat$District[i])
  ifelse(agrepl('Kandhkot', dat$Place[i]), dat$District[i] <- 'Kashmore', dat$District[i])
  ifelse(agrepl('Dera Allah Yar', dat$Place[i]), dat$District[i] <- 'Jafarabad', dat$District[i])
  ifelse(agrepl('Kahan', dat$Place[i]), dat$District[i] <- 'Kohlu', dat$District[i])
  ifelse(agrepl('Baidara', dat$Place[i]), dat$District[i] <- 'Swat', dat$District[i])
  ifelse(agrepl('Aiman Abad', dat$Place[i]), dat$District[i] <- 'Gujranwala', dat$District[i])
  ifelse(agrepl('Miranshah', dat$Place[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
  ifelse(agrepl('Paharpur', dat$Place[i]), dat$District[i] <- 'Dera Ismail Khan', dat$District[i])
  ifelse(agrepl('Kolpur', dat$Place[i]), dat$District[i] <- 'Mastung', dat$District[i])
  ifelse(agrepl('Bajaur', dat$Place[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
  ifelse(agrepl('Pasni', dat$Place[i]), dat$District[i] <- 'Gwadar', dat$District[i])
  ifelse(agrepl('Killi Omar', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Green Town', dat$Place[i]), dat$District[i] <- 'Lahore', dat$District[i])
  ifelse(agrepl('Khyber', dat$Place[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
  ifelse(agrepl('Hub', dat$Place[i]), dat$District[i] <- 'Lasbela', dat$District[i])
  ifelse(agrepl('Kurram', dat$Place[i]), dat$District[i] <- 'Kurram Agency', dat$District[i])
  ifelse(agrepl('Mamond', dat$Place[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
  ifelse(agrepl('Wadh', dat$Place[i]), dat$District[i] <- 'Khuzdar', dat$District[i])
  ifelse(agrepl('Dangeen', dat$Place[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
  ifelse(agrepl('Gosh', dat$Place[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
  ifelse(agrepl('Dosli', dat$Place[i]), dat$District[i] <- 'North Waziristan', dat$District[i])
  ifelse(agrepl('Nawagai', dat$Place[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
  ifelse(agrepl('Dir', dat$Place[i]), dat$District[i] <- 'Upper Dir', dat$District[i])
  ifelse(agrepl('Landi Kotal', dat$Place[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
  ifelse(agrepl('Bostan', dat$Place[i]), dat$District[i] <- 'Pishin', dat$District[i])
  ifelse(agrepl('Bhojpur', dat$Place[i]), dat$District[i] <- 'Gujrat', dat$District[i])
  ifelse(agrepl('Saddar', dat$Place[i]), dat$District[i] <- 'Rawalpindi', dat$District[i])
  ifelse(agrepl('Askari', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Akhtarabad', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Parkaniabad', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Parkaniabad', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Gandoi', dat$Place[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
  ifelse(agrepl('Sariab', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Sakran Road', dat$Place[i]), dat$District[i] <- 'Lasbela', dat$District[i])
  ifelse(agrepl('Pash Bogi', dat$Place[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
  ifelse(agrepl('Lakpass', dat$Place[i]), dat$District[i] <- 'Mastung', dat$District[i])
  ifelse(agrepl('Tausa', dat$Place[i]), dat$District[i] <- 'Dera Ghazi Khan', dat$District[i])
  ifelse(agrepl('Matta', dat$Place[i]), dat$District[i] <- 'Swat', dat$District[i])
  ifelse(agrepl('Kajla Mor', dat$Place[i]), dat$District[i] <- 'Nasirabad', dat$District[i])
  ifelse(agrepl('Bara', dat$Place[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
  ifelse(agrepl('Mand', dat$Place[i]), dat$District[i] <- 'Kech', dat$District[i])
  ifelse(agrepl('Manikhel', dat$Place[i]), dat$District[i] <- 'Mardan', dat$District[i])
  ifelse(agrepl('Naway Qamar', dat$Place[i]), dat$District[i] <- 'Khyber Agency', dat$District[i])
  ifelse(agrepl('Loti', dat$Place[i]), dat$District[i] <- 'Dera Bughti', dat$District[i])
  ifelse(agrepl('Mawind', dat$Place[i]), dat$District[i] <- 'Kohlu', dat$District[i])
  ifelse(agrepl('Khar', dat$Place[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
  ifelse(agrepl('Inayet Kali', dat$Place[i]), dat$District[i] <- 'Bajaur Agency', dat$District[i])
  ifelse(agrepl('Bilitang', dat$Place[i]), dat$District[i] <- 'Kohat', dat$District[i])
  ifelse(agrepl('Samungli', dat$Place[i]), dat$District[i] <- 'Quetta', dat$District[i])
  ifelse(agrepl('Kabal', dat$Place[i]), dat$District[i] <- 'Swat', dat$District[i])
  for(j in 1:length(districts)) {
    if (grepl(districts[j], dat$Place[i])) {
      dat$District[i] <- districts[j]
    } else {
      dat$District[i]
    }
    if (is.na(dat$District[i])) {
      if (agrepl(districts[j], dat$Place[i])) {
        dat$District[i] <- districts[j]
      } else {
        dat$District[i]
      }
    } else {
      dat$District[i]
    }
  }
}   

missing_distr <- dat[is.na(dat$District),]
nrow(missing_distr)
missing_distr

# Check for missing districts
nmissing_distr <- nrow(subset(dlist[[k]], is.na(District)))
for(i in 1:length(nmissing_distr)){
  nmissing_distr[i] <- nmissing
}





## Do again for Provinces
for(i in 1:nrow(dat)) {
  ifelse(agrepl('Bolan', dat$Place[i]), dat$District[i] <- 'Kachhi', dat$District[i] <- dat$District[i])
  ifelse(agrepl('SWA', dat$Place[i]), dat$District[i] <- 'South Waziristan', dat$District[i] <- dat$District[i])
  for(j in 1:length(districts)) {
    ifelse(agrepl(districts[j], dat$Place[i], max = 2), dat$District[i] <- districts[j], dat$District[i] <- dat$District[i])
  }
}

dat_distr.unmatched <- subset(dat, is.na(District))
nrow(dat_distr.unmatched)
show(dat_distr.unmatched)








for(i in 1:length(dlist)){
  vector <-
    dlist[[i]]$Year <- vector # Add year columns to data.frames
}
#place <- data.frame(do.call('rbind', strsplit(as.character(dat$Place),'/',fixed=TRUE)))
