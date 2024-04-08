#### merge daily and monthly station list, so that if both daily and monthly exist they are merged
#setwd('C:/Users/sbusr/Desktop/Tez/Practical/data')
####-------------------------------####
source('/Users/SBK/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####

stations_daily <- read.csv('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_daily.csv')
stations_monthly <- read.csv('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_monthly.csv')

stations_dm <- merge(stations_daily, stations_monthly, 
                     by=intersect(names(stations_daily), names(stations_monthly)), 
                     all=TRUE)
write.csv(stations_dm,'/Users/SBK/Desktop/Tez/Practical/data/stationLatLon.csv', row.names=F)
