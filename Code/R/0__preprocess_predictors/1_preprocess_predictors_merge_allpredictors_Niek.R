####-------------------------------####
source('/Users/SBK/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####

stationInfo <- read.csv(paste0('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon.csv'))
stationInfo <- stationInfo %>% filter(grdc_no != 6233528) # not present in catchment attribute data

filePathCatchAttr <- paste0('/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_parameters/')
filePathStatevars <- paste0('/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_qMeteoStatevars/')
filePathSatelVars <- paste0('/Users/SBK/Desktop/Tez/Practical/data/predictors/satellite/')

outputDir <- paste0('/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_allpredictors/')
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)
file.remove(list.files(outputDir, full.names = TRUE))


### function to merge tables of time-variant and statics predictors
merge_predictors <- function(i){
  
  station_no <- i
  # print(station_no)
  
  CatchAttrTable <- read.csv(paste0(filePathCatchAttr , 'pcr_parameters_',station_no,'.csv'))
  statevarsTable <- read.csv(paste0(filePathStatevars , 'pcr_qMeteoStatevars_',station_no,'.csv'))
  satelliteTable <- read.csv(paste0(filePathSatelVars , 'sat_predictors_', station_no, '.csv'))
  
  #df_list = list(CatchAttrTable,
  #               statevarsTable,
  #               satelliteTable)
  
  #allPredictors <- df_list %>% reduce(merge, by='datetime') %>%
   # mutate(datetime = as.Date(datetime))
  allPredictors <- inner_join(statevarsTable, CatchAttrTable, by = 'datetime') %>%
    inner_join(satelliteTable, by = 'datetime') %>%
    mutate(datetime = as.Date(datetime))
  
  
  write.csv(allPredictors, paste0(outputDir, 'pcr_allpredictors_',station_no,'.csv'), row.names=FALSE)
  #print(paste0('Progress: ', progress,'%'))
  
  
}
mclapply(stationInfo$grdc_no, merge_predictors, mc.cores=cores)


