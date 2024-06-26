#### processing ####
calculate_missing <- function(i){ 
  
  station_no <- i
  
  grdDir <- '/Users/SBK/Desktop/Tez/Practical/data/preprocess/grdc_discharge/grdc_'
  satDir <- paste0('/Users/SBK/Desktop/Tez/Practical/data/predictors/satellite_all/sat_predictors_')
  
  grdFile <- paste0(grdDir, station_no,'.csv')
  satFile <- paste0(satDir, station_no,'.csv')
  
  fully_missing <- c()
  if(file.exists(grdFile) & file.exists(satFile)){
    grd <- read.csv(grdFile)
    sat <- read.csv(satFile)
    
    obs <- inner_join(grd, sat, by = 'datetime')
    
    obs <- obs %>% filter(datetime >= startDate & datetime <= endDate) %>% 
      select(-datetime)
    
    missings <- apply(obs, 2, function(x) sum(is.na(x)))
    missing_perc <- round((missings / nrow(obs)) * 100, 2)
    
    
    if (any(missing_perc == 100)){
      fully_missing <-  as.integer(station_no)
    }else{fully_missing <-  0}
    
    if (nrow(drop_na(obs)) == 0){
      fully_missing <- as.integer(station_no)
    }
    
  }else{
    print(paste0(station_no, ': sat or grdc doesnt exist'))
    missing_perc <- 100
  }
  names(station_no) <- 'grdc_no'
  return(c(missing_perc, station_no))
}