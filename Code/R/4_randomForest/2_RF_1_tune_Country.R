####-------------------------------####
source('/home/2787849/Practical/data/fun_0_loadLibrary.R')
source('/home/2787849/Practical/data/project_settings.R')
###-------------------------------####
source('/home/2787849/Practical/data/R/4_randomForest/fun_2_1_hyperTuning.R')

#--------------RF---------------
#-----------1. Tune parameter---------------#


RF_tune_subsamples <- function(subsample, country, run, ntree_vector, mtry_vector){
  print(paste0('subsample: ', subsample))
  
  train_data <- vroom(paste0('/home/2787849/Practical/RF/0_rf_input/', 'subsample_',subsample,'_', country,
                             '/train_table_',run,'.csv'), show_col_type=F)
  
  outputDir <- paste0('/home/2787849/Practical/RF/1_tune/subsample_',subsample,'_',country,'/')
  dir.create(outputDir, showWarnings = F, recursive = T)
  
  print(paste0('tuning: ', run))
  rf_input <- train_data %>%  select(-datetime)
  
  mtry_vector <- mtry_vector[mtry_vector < length(names(rf_input))]
  
  hyper_grid <- expand.grid(
    ntrees = ntree_vector,
    mtry = mtry_vector
  )
  
  hyper_trains <- lapply(1:nrow(hyper_grid), hyper_tuning, hyper_grid, rf_input)
  
  for(i in 1:nrow(hyper_grid)){
    hyper_grid$ntrees[i]   <- hyper_trains[[i]]$num.trees
    hyper_grid$mtry[i]     <- hyper_trains[[i]]$mtry
    hyper_grid$OOB_RMSE[i] <- sqrt(hyper_trains[[i]]$prediction.error)
  }
  
  file <- paste0(outputDir, 'hyper_grid_',run, '_mtry_ntrees.csv')
  print(paste0('output csv file: ', file))
  write.csv(hyper_grid, file, row.names = F)
  
  min_vals <- hyper_grid %>% filter(OOB_RMSE == min(OOB_RMSE))
  
  return (c(min_vals$ntrees, min_vals$mtry))
}
# var_select #####

countries <- c('all','US')
ntree <- c(200)
mtrys <- c(35,30,27,25,24,23,22,21,20,19,18,17,16,15,14,4,3)


for (country in countries){
  if (country =='all'){
    gridnames <-  c('predictors_pcr','predictors_pcr_sat', 'predictors_pcr_sat_add',
        'predictors_pcr_sat_E','predictors_pcr_sat_E_add','predictors_pcr_sat_pr','predictors_pcr_sat_pr_add',
             'predictors_sat_meteo', 'predictors_sat_meteo_static','predictors_meteo_static',
                'predictors_meteo_static','predictors_sat_static')

  }else{
    gridnames <-c('predictors_pcr','predictors_pcr_sat', 'predictors_pcr_sat_add',
        'predictors_pcr_sat_E','predictors_pcr_sat_E_add','predictors_pcr_sat_pr','predictors_pcr_sat_pr_add',
             'predictors_sat_meteo', 'predictors_sat_meteo_static','predictors_meteo_static',
                'predictors_meteo_static','predictors_sat_static')
  }
  tuned_mtry <- list()
  tuned_ntree <- list()
  for (sample in 1:samples){
    tuned_mtry[[paste0('sample ', sample, ':')]] <- 0
    tuned_ntree[[paste0('sample ', sample, ':')]] <- 0
    
    for (p in 1:length(gridnames)){
      start <- Sys.time() 
      
      tuned_vars <- RF_tune_subsamples(sample,country,gridnames[p] , ntree, mtrys)
      tuned_ntree[[sample]][gridnames[p]] <- tuned_vars[1]
      tuned_mtry[[sample]][gridnames[p]] <- tuned_vars[2]
      
      end <- Sys.time()
      print(end - start)
    }
  }
  write.csv(do.call(rbind, tuned_ntree)[,1:length(gridnames)+1], paste0('/home/2787849/Practical/RF/1_tune/tuned_ntree_',country,'.csv'), row.names = T)
  write.csv(do.call(rbind, tuned_mtry)[,1:length(gridnames)+1], paste0('/home/2787849/Practical/RF/1_tune/tuned_mtry_',country,'.csv'), row.names = T)
}

