####-------------------------------####
source('/Users/SBK/Desktop/Tez/Practical/data/fun_0_loadLibrary.R')
####-------------------------------####

#### create big table with all predictors to execute corranalysis ####
filePathPreds <- '/Users/SBK/Desktop/Tez/Practical/data/predictors/pcr_allpredictors/'
fileListPreds <- list.files(filePathPreds)
filenames <- paste0(filePathPreds, fileListPreds)

print('reading all tables...')

all_tables <- mclapply(filenames, vroom, show_col_types = F)
print('binding...')
bigTable <- do.call(rbind, all_tables)
bigTable <- na.omit(bigTable)

print('writing to disk...')
write.csv(bigTable, '/Users/SBK/Desktop/Tez/Practical/data/bigTable_allpredictors.csv' , row.names = F)

