# select region if different runs besides global are needed

stationInfo <- read.csv(paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon.csv'))

canada    <- stationInfo %>% filter(country == 'CA')
write.csv(canada, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_CA.csv'), row.names=F)

australia <- stationInfo %>% filter(country == 'AU')
write.csv(australia, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_AU.csv'), row.names=F)

USA       <- stationInfo %>% filter(country == 'US') 
write.csv(USA, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_US.csv'), row.names=F)

global    <- stationInfo
write.csv(stationInfo, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_all.csv'), row.names=F)

Brazil       <- stationInfo %>% filter(country == 'BR') 
write.csv(USA, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_BR.csv'), row.names=F)

Russia       <- stationInfo %>% filter(country == 'RU') 
write.csv(USA, paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_selected_RU.csv'), row.names=F)