####-------------------------------####
source('C:/Users/sbusr/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####



outputDir <- 'C:/Users/sbusr/Desktop/Practical/data/vizKGE/'
dir.create(outputDir, showWarnings = F, recursive = T)


regions <- c('all')


if (regions[1] == 'all'){
  setup <- c('predictors_pcr.csv','predictors_pcr_sat.csv', 'predictors_pcr_sat_add.csv',
             'predictors_sat_meteo.csv','predictors_sat_meteo_static.csv', 'predictors_meteo_static.csv')
  #setup <- c('predictors_pcr.csv','predictors_pcr_sat_add.csv',
  #           'predictors_pcr_sat.csv')
  
  plotLevels <- c(#'uncalibrated',
    str_sub(setup, start = 12,end = -5))
  
  colors <- c('#ffdf20', '#17FF00','#0029F8','#ff7f00', '#33a02c', '#e31a1c', '#1f78b4')
}else{
  print("No available region.")
}

# Call the function with appropriate arguments
# Call the function with appropriate arguments
country_code <- "US"
file_path <- "C:/Users/sbusr/Desktop/Practical/data/stationLatLon_selected_US.csv"
grdc_data <- read.csv(file_path, stringsAsFactors = FALSE)

#### data preparation ####
region_count <- 1
country_data_list <- list()
for (c in regions){
  subsample_KGE_list <- list ()
  
  for(subsample in 1:5){
    
    rf.eval.uncalibrated <- read.csv(paste0('C:/Users/sbusr/Desktop/Practical/RF/3_validate/subsample_', subsample,'_',c,
                                            '/KGE_predictors_pcr.csv')) %>%
      select(.,grdc_no, KGE, KGE_r, KGE_alpha, KGE_beta) %>%
      mutate(.,setup=factor('uncalibrated')) %>%
      mutate(.,subsample=factor(subsample))
    # 
    read_metrics <- function(setup, subsample){
      setup <- str_sub(setup, end = -5)
      setup_factor <- gsub('_', ' ', str_sub(setup, start = 12))
      print(setup_factor)
      print(setup)
      rf.eval <- read.csv(paste0('C:/Users/sbusr/Desktop/Practical/RF/3_validate/subsample_', subsample,'_',c,
                                 '/KGE_',setup,'.csv')) %>% 
        select(.,grdc_no, KGE_corrected, KGE_r_corrected, KGE_alpha_corrected, KGE_beta_corrected) %>% 
        rename(., KGE=KGE_corrected, KGE_r=KGE_r_corrected, KGE_alpha=KGE_alpha_corrected, KGE_beta=KGE_beta_corrected) %>% 
        mutate(.,setup=factor(setup_factor)) %>% 
        mutate(.,subsample=factor(subsample)) 
      return (rf.eval)
    }
    subsample_KGE <- rf.eval.uncalibrated
    for (s in setup){
      rf.eval        <- read_metrics(s, subsample)
      subsample_KGE <- rbind(subsample_KGE, rf.eval)
    }
    
    subsample_KGE_list[[subsample]] <- subsample_KGE
  }
  allData <- do.call(rbind, subsample_KGE_list)
  selected_data <- grdc_data %>% select (grdc_no)
  selected_rows <- allData[allData$grdc_no %in% selected_data$grdc_no, ]
  plotData <- selected_rows %>% group_by(grdc_no, setup) %>% summarise(mean_KGE = mean(KGE),
                                                                 mean_KGE_r = mean(KGE_r),
                                                                 mean_KGE_a = mean(KGE_alpha),
                                                                 mean_KGE_b = mean(KGE_beta)
  ) 
  
  #plotData$setup <- factor(plotData$setup, levels = plotLevels) # change order of plotLevels for different order 
  plotData$setup <- factor(plotData$setup) # change order of plotLevels for different order 
  
  # plot all ecdf #####
  plot_text_size <- 30 
  plot <- ggplot(plotData, aes(mean_KGE, color = setup)) +
    stat_ecdf(geom = 'step', linewidth = 2) + # 2 for thesis 1 for poster
    coord_cartesian(xlim=c(-1,1))+
    labs(title = country_code, y = 'ECDF', x='Square root of KGE')+
    scale_color_manual(values=colors)+
    theme(plot.title   = element_text(size=plot_text_size),
          axis.title.y = element_text(size=plot_text_size),
          axis.text.y  = element_text(size=plot_text_size -5),
          axis.title.x = element_text(size=plot_text_size),
          axis.text.x  = element_text(size=plot_text_size -5),
          
          panel.border= element_rect(linetype = 1, fill = NA),
          legend.position = 'bottom',
          legend.title=element_blank(),
          legend.key.size = unit(1, 'cm'),
          legend.text = element_text(size=plot_text_size + 5),
          strip.text = element_text(size=plot_text_size))
  
  
  ggsave(paste0('C:/Users/sbusr/Desktop/Practical/data/vizKGE/PDF_ecdf_global_training_', country_code, '.pdf'),plot,height=20, width=20, units='in', dpi=600) 
}