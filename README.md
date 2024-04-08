# PCR-GLOBWB-RF-satellitedata

Global reanalysis of the PCR-GLOBWB model using Random Forest and satellite-basd precipitation and evaporation. 
Project is made for the Earth Surface and Water master thesis and is an continuation of another master thesis by Niek Collot d’Escury (2023) and scientific research by Magni et al. (2023)

## Input data
Input data and outputs of the 30 arcmin run are available on Zenodo ([input](https://doi.org/10.5281/zenodo.7890583), [output](https://doi.org/10.5281/zenodo.7891352), [validation hydrographs](https://doi.org/10.5281/zenodo.7893903)), obtained from Magni et al. (2023).

## Python module
For fast installation / update of necessary modules it is recommended to use the mamba package manager.
Current dependencies: numpy, pandas, alive_progress, netCDF4, xarray, multiprocessing.

The python module is used to normalize the static parameters from PCR-GLOBWB and for the normalization of the satellite products

Following the normalization process for the satellite data, values are then retrieved for GRDC stations.

## R module 
The R module follows the post-processing phases described in manuscript. Dependencies can be installed using fun_0_install_dependencies.R. These are loaded at the beginning of each script using fun_0_load_library.R.

### Project_settings
Set settings for all codes
1. period: 2000-06-01 untill 2019-12-01
2. define number of available computer cores
3. define the selected satellite products
4. settings for the Random Forest model
5. Choose the number of random subsamples

### 0_preprocess_grdc
Merges stations from stationLatLon_daily.csv and stationLatLon_monthly.csv into stationLatLon.csv

### 0_preprocess_predictors
Parameters: generates timeseries of static catchment attributes (.csv)
qMeteoStatevars: merges timeseries of meteo input and state variables (.csv)
satellite: merges the different satellite products (.csv)
Merge all predictors : merges Parameters, qMeteoStatevars and satellite products (.csv)

### 1_preprocess_selectRegion
Choose different regions for analysis (.csv)

### 2_preprocess_checkMissing
calculate number of missing values for the selected period

### 3_correlation_analysis
bigTable : binds all stations predictor tables allpredictors

### 4_randomForest
1. Select different variable combinations to use in the random forest
2. generate a training table that contains ~70% of all available timesteps.
3. Tune -> Uses training table from 0 to tune Random Forest hyperparameters.
4. Train / Testing -> Calculates variable importance and KGE (before and after post-processing).

### 5_visualization
Used to visualize all modelling phases:
- Map with percentage of missing data at GRDC stations.
- Tuning Random Forest parameters.
- Plot of variable importance with uncertainty averaged for all subsamples.
- KGE: boxplots of each subsample and predictor configuration.
- KGE: cumulative distribution plots averaged over de the subsamples for each configuration and location
- Hydrographs: can be done for selected stations or in batch for all subsamples (only for allpredictors setup).
