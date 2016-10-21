setwd("C:/Users/user/Documents/Git/statistan-data/SATP/bomb blasts")

# Load in all datasets by year
dat2000 <- read.csv("bbdata2000")

a <- 2001
b <- 2016

for(i in a:b){
  filename <- paste0("bbdata", i)
  assign(paste0("dat", i), read.csv(filename))
}

# Add corresponding year value to each data.frame & drop Pandas index column

c <- 2000
years <- seq(c, b, by = 1)

dlist <- lapply(ls(pattern = 'dat'), get)
names(dlist) <- rep(NA, length(dlist))

for(i in 1:length(dlist)){
  dlist[[i]] <- dlist[[i]][,-1] # Drop index column
  names(dlist)[i] <- toString(years[i])
  vector <- rep(as.numeric(names(dlist)[i]), nrow(dlist[[i]]))
  dlist[[i]]$Year <- vector # Add year columns to data.frames
}

# Split "Place" by "/"





within(dat, Place <- data.frame(do.call('rbind', strsplit(as.character(Place), '/', fixed = TRUE))))

place <- data.frame(do.call('rbind', strsplit(as.character(dat$Place),'/',fixed=TRUE)))

head(dat)
