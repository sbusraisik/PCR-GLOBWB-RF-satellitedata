#setwd('C:/Users/sbusr/Desktop/Tez/Practical/data')
####-------------------------------####
source('/Users/SBK/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
source('/Users/SBK/Desktop/Tez/Practical/data/project_settings.R')
####-------------------------------####

#### set-up ####
stationInfo <- read.csv('/Users/SBK/Desktop/Tez/Practical/data/stationLatLon_catchAttr.csv') # catchment attribute file for all stations
outputDir   <- '/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_parameters/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# datetime as pcr-globwb run
dates <- as.data.frame(seq(as.Date(startDate), as.Date(endDate), by="month"))
colnames(dates) <- 'datetime'

#### run ####
source('/Users/SBK/Desktop/Tez/Practical/data/R/0_preprocess_predictors/fun_0_preprocess_pcr_parameters.R')
mclapply(stationInfo$grdc_no, create_predictor_table, mc.cores=cores)

