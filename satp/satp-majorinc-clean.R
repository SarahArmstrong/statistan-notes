setwd("C:/Users/user/Documents/Git/statistan-data/SATP/major incidents")

dat_ <- read.csv("midata1988-2006")
dat_ <- dat_[,2]

yrs <- as.character(seq(1988, 2006, 1))

yrs.dat_index <- sapply(yrs, function(y) grep(y,dat_))
yrs.dat_index <- yrs.dat_index[lapply(yrs.dat_index, length) > 0]
yrs.dat_index <- unlist(yrs.dat_index)
yrs.dat_index <- yrs.dat_index[order(yrs.dat_index)]
yrs.dat_index <- as.list(yrs.dat_index)

splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))
dat_ <- splitAt(dat_, yrs.dat_index)


for (i in 1:14) {
  assign(paste0("dat", dat_[[i]][1]), as.data.frame.list(dat_[i]))  
}

a <- 2007
b <- 2016
for(i in a:b){
  filename <- paste0("midata", i)
  assign(paste0("dat", i), read.csv(filename))
}


