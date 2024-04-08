####-------------------------------####
source('/Users/SBK/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####

stationInfo <- read.csv('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon.csv')

#grdc stations full discharge time series
filePathGrdc <- paste0('/Users/SBK/Desktop/Tez/Practical/data/preprocess/grdc_discharge/')
# pcr-globwb discharge time series
filePathDischarge <- paste0('/Users/SBK/Desktop/Tez/Practical/data/preprocess/pcr_discharge/')
# pcr-globwb stateVars discharge time series 
filePathStatevars <- paste0('/Users/SBK/Desktop/Tez/Practical/data/preprocess/pcr_statevars/')

outputDir <- '/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_qMeteoStatevars/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# datetime as pcr-globwb run based on project settings dates
dates <- seq(as.Date(startDate), as.Date(endDate), by="month")

source('/Users/SBK/Desktop/Tez/Practical/data/R/0_preprocess_predictors/fun_0_preprocess_pcr_qMeteoStatevars.R')
mclapply(stationInfo$grdc_no, create_predictor_table, mc.cores=cores)
