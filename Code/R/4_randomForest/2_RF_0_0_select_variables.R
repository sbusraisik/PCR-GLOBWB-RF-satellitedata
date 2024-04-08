####-------------------------------####
source('/home/2787849/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####
# create different RF model configurations to be used in the analysis


filePath <- '/home/2787849/Practical/data/predictors/pcr_allpredictors/pcr_allpredictors_1134300.csv'
variables <- tibble(names = names(read.csv(filePath)))

# Static list #####
static <- c('airEntry1', 
            'airEntry2' ,
            'aqThick' ,
            'aridityIdx',
            'bankArea' ,
            'bankDepth' ,
            'bankWidth' ,
            'demAverage',
            'forestFraction' ,
            'groundwaterDepth',
            'KSat1' ,
            'KSat2' ,
            'kSatAquifer', 
            'recessionCoeff',
            'resWC1' ,
            'resWC2' ,
            'satWC1' ,
            'satWC2' ,
            'slopeLength', 
            'specificYield',
            'storage1' ,
            'storage2' ,
            'storDepth1', 
            'storDepth2' ,
            'tanSlope' ,
            'catchment',
            'poreSize1',
            'poreSize2',
            'percolationImp')
#####

sat          <- variables$names[grep(pattern = 'pr$','Evaporation$', variables$names)] #LAI will be added later.
pcr          <- variables$names[!variables$names %in% c(sat)]

#pcrmeteo <- variables %>% 
#  filter(names %in% c('obs' ,'snowCoverSWE', 'storUppTotal', 'storGroundwater'
#                      , 'storLowTotal', 
#                      'precipitation', 'temperature', 'referencePotET'))
#pcrmeteostatic <-  variables %>% 
#  filter(names %in% c('obs' ,'snowCoverSWE', 'storUppTotal', 'storGroundwater'
#                      , 'storLowTotal', 
#                      'precipitation', 'temperature', 'referencePotET', static))

#write.csv(pcrmeteo, 'C:/Users/sbusr/Desktop/Tez/Practical/data/predictors_pcrLim_meteo.csv',row.names = F)
#write.csv(pcrmeteostatic, 'C:/Users/sbusr/Desktop/Tez/Practical/data/predictors_pcrLim_meteo_static.csv',row.names = F)


predictors_pcr <- variables %>% filter(!names %in% c('datetime'), names %in% pcr)

predictors_pcr_sat_add <- variables %>% filter(!names %in% c('datetime')) #both pr and E added

predictors_pcr_sat <- variables %>% filter(!names %in% c('datetime','precipitation', 'totalEvaporation')) #both pr and E replaced

predictors_pcr_sat_pr_add <- variables %>% filter(!names %in% c('datetime','E')) #only pr added

predictors_pcr_sat_pr <- variables %>% filter(!names %in% c('datetime','precipitation','E')) #only pr replaced

predictors_pcr_sat_E_add <- variables %>% filter(!names %in% c('datetime','pr')) #only E added

predictors_pcr_sat_E <- variables %>% filter(!names %in% c('datetime','pr','totalEvaporation')) #only E replaced

sat_meteo_predictors_static <- variables %>% 
  filter(names %in% c('obs', 'pr', 'E',
                      'precipitation', 'temperature', 'referencePotET', static))

sat_meteo_predictors <- variables %>% 
  filter(names %in% c('obs', 'pr', 'E',
                      'precipitation', 'temperature', 'referencePotET'))

# write files ######

write.csv(predictors_pcr, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr.csv',row.names = F)
write.csv(predictors_pcr_sat_add, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat_add.csv',row.names = F)
write.csv(predictors_pcr_sat, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat.csv',row.names = F)
write.csv(predictors_pcr_sat_pr_add, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat_pr_add.csv',row.names = F)
write.csv(predictors_pcr_sat_pr, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat_pr.csv',row.names = F)
write.csv(predictors_pcr_sat_E_add, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat_E_add.csv',row.names = F)
write.csv(predictors_pcr_sat_E, '/Users/SBK/Desktop/Tez/Practical/data/predictors_pcr_sat_E.csv',row.names = F)
write.csv(sat_meteo_predictors_static, '/Users/SBK/Desktop/Tez/Practical/data/predictors_sat_meteo_static.csv',row.names = F)
write.csv(sat_meteo_predictors, '/Users/SBK/Desktop/Tez/Practical/data/predictors_sat_meteo.csv',row.names = F)















