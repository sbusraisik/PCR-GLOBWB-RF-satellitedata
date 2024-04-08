####-------------------------------####
source('/home/2787849/Practical/data/fun_0_loadLibrary.R')
source('/home/2787849/Practical/data/project_settings.R')
####-------------------------------####
source('/home/2787849/Practical/data/R/4_randomForest/fun_2_2_trainRF.R')
source('/home/2787849/Practical/data/R/4_randomForest/fun_2_3_apply_optimalRF.R')

#-------train RF with tuned parameters on 70% of available observations----------
trees <- 1000 # almost always 700 trees so stick to 700
#trees <- 10 # almost always 700 trees so stick to 700


countries <- c('all','AU','BR','CA','RU','US','ZA')
#countries <- c('all')

for (country in countries){
  tuned_mtry <- read.csv(paste0('/home/2787849/Practical/RF/1_tune/tuned_mtry_',country,'.csv'), header=T)  %>% 
    select(-X)
  
  filePathRF <- paste0('/home/2787849/Practical/data/')
  RF_input_list <- list.files(filePathRF, pattern = 'predictors_')
 
  for (RF in RF_input_list){
    output <- str_sub(RF, end = -5)
    print(output)
    
    for(subsample in 1:samples){
      
      print(paste0('subsample: ', subsample))
      #select subsample predictors
      train_data <- vroom(paste0('/home/2787849/Practical/RF/0_rf_input/', 'subsample_',subsample,'_',country,
                                 '/train_table_',output,'.csv'), show_col_type=F)
      testStationInfo <- read.csv(paste0('/home/2787849/Practical/RF/0_rf_input/subsample_',subsample,'_',
                                         country,'/test_stations.csv'))
      
      outputDir <- paste0('/home/2787849/Practical/RF/2_train/subsample_',subsample,'_',country,'/')
      dir.create(outputDir, showWarnings = F, recursive = T)
      outputDirValidation <- paste0('/home/2787849/Practical/RF/3_validate/subsample_',subsample,'_',country,'/')
      dir.create(outputDirValidation, showWarnings = F, recursive = T)
      
      
      rf_input <- train_data %>% select(-datetime, -id)
      
      
      mtry <- tuned_mtry[subsample, output]
      
      optimal_ranger <- trainRF(input_table=rf_input, num.trees=trees, mtry=mtry)
      
      vi_df <- data.frame(names=names(optimal_ranger$variable.importance)) %>%
        mutate(importance=optimal_ranger$variable.importance) %>% arrange(importance)                    
      write.csv(vi_df, paste0(outputDir,paste0('varImportance_',output,'.csv')), row.names=F)
      
      #run validation script
      key=output
      print(paste0(key,' : calculation initiated...'))
      
      KGE_lists <- list()
      
      for (i in 1:nrow(testStationInfo)){
        KGE_lists[[i]] <- apply_optimalRF(i, key)
        
      }
      rf.eval <- do.call(rbind,KGE_lists)
      
      # KGE_list <- mclapply(1:nrow(testStationInfo), key=key, apply_optimalRF, mc.cores=cores)
      # rf.eval <- do.call(rbind,KGE_list)
      write.csv(rf.eval, paste0(outputDirValidation, 'KGE_' , key, '.csv'), row.names = F)
      
      # print(paste0(key,' :  finished validation...'))
      
    }
  }
}
