####-------------------------------####
source('C:/Users/sbusr/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####
library('ggh4x')
outputDir <- paste0('C:/Users/sbusr/Desktop/Practical/data/viz/')
dir.create(outputDir, showWarnings = F, recursive = T)

sc <- scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#CC79A7"), 
                         name='Subsample: ')

countries <- c('all')

plot_text <- 15

outputDir <- paste0('C:/Users/sbusr/Desktop/Practical/data/viz/tuningPlots/')
dir.create(outputDir, showWarnings = F, recursive = T)
#### tuning mtry ####

 country <- c('all')

setup <- c('predictors_pcr','predictors_pcr_sat', 'predictors_pcr_sat_add',
             'predictors_sat_meteo', 'predictors_sat_meteo_static',
             'predictors_pcr_sat_pr_add', 'predictors_pcr_sat_pr','predictors_pcr_sat_E_add',
             'predictors_pcr_sat_E','predictors_meteo_static')

  
  for(i in 1:length(setup)){
    mtryTuningList <- list()
    for(subsample in 1:5){
      
      tuning_dir <- paste0('C:/Users/sbusr/Desktop/Practical/RF/1_tune/subsample_',subsample,'_',country,'/')
      
      mtry_file <- read.csv(paste0(tuning_dir, 'hyper_grid_',setup[i],'_mtry_ntrees.csv'))
      
      mtry_tuning <- mtry_file %>% arrange(.,mtry) %>% 
        mutate(.,subsample=factor(subsample))
      mtryTuningList[[subsample]] <- mtry_tuning
    }
    
    all_mtry_setup <- do.call(rbind, mtryTuningList)  
    mtryPlotData <- all_mtry_setup %>% pivot_longer(.,OOB_RMSE)
    mtryPlotData <- mtryPlotData %>% select(-ntrees)
    mtryPlotData['setup'] <- gsub(pattern = '_',replacement = ' ',  str_sub(setup[i], start = 12))
    
    mtryPlot <- ggplot(mtryPlotData, aes(x=mtry,y=value, group=subsample, color=subsample))+
      geom_line(linewidth=2.5)+
      geom_point(aes(shape=subsample), size=4.5, alpha = 1, show.legend = F) +
      sc+
      # scale_x_continuous(minor_breaks = minorBreaks, breaks = Breaks)+
      ylab('OOB RMSE (m/d)\n')+
      labs(title=paste(country,setup[i]))+
      # theme_minimal()+
      theme(plot.title = element_text(hjust = 0.5, size=plot_text, face='bold'),
            axis.title.y = element_text(size=plot_text),
            axis.text.y  = element_text(size=plot_text),
            axis.title.x = element_text(size=plot_text),
            axis.text.x  = element_text(size=plot_text),
            
            legend.title=element_blank(),
            legend.key.size = unit(3, 'cm'),
            legend.text = element_text(size=55))
    
    ggsave(paste0(outputDir,paste0('tuningPlot_',country,'_',setup[i],'.jpeg')), mtryPlot, height=8, width=10, units='in', dpi=600)
  }
