#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import pcraster as pcr
import numpy as np
from netCDF4 import Dataset
import rioxarray
import pandas as pd
import matplotlib.pyplot as plt
import glob
import re
import time
from multiprocess import Pool
import tqdm

# set your working directory
directoryMain = 'C:/Users/sbusr/Desktop/Tez/Practical/data/satellite_data/'
directoryArea = 'C:/Users/sbusr/Desktop/Tez/Practical/data/satellite_data/'

# change working directory
os.chdir(directoryMain)

# get grid area: all products should have same grid
os.system('cdo gridarea E_1980-2022_GLEAM_v3.8a_MO.nc area/gridarea30min.nc')

# transform to tiff
os.system('gdal_translate area/gridarea30min.nc  area/gridarea30min.tif')
os.system('gdal_translate area/lddsound_30min.nc area/lddsound_30min.tif')

# transform from tiff to map (pcraster format)
os.system('gdal_translate -of PCRaster area/gridarea30min.tif  area/gridarea30min.map')
os.system('gdal_translate -of PCRaster area/lddsound_30min.tif area/lddsound_30min.map')
os.system('rm *.xml') # remove redundant files

# change directory for ldd calculation
os.chdir(directoryArea)
# transform ldd map to .ldd format
os.system('pcrcalc lddsound_30min.ldd = "lddrepair(ldd(lddsound_30min.map))"')
# aguila lddsound_30min.ldd --> command in terminal for viewing the map

# reset working directory
os.chdir(directoryMain)

# define cell area file and ldd file
cell_area_file = "area/gridarea30min.map"
ldd_file       = "area/lddsound_30min.ldd"

# calculate catchment area
# - set clone, the bounding box of your study area - here, we use ldd 
clone_file     = ldd_file
pcr.setclone(clone_file)
# - read cell_area and ldd files
cell_area = pcr.readmap(cell_area_file)
ldd       = pcr.readmap(ldd_file)

# - calculate catchment area
catchment_area = pcr.catchmenttotal(cell_area, ldd)
# - save catchment_area to a file - note the file output will be under the work_dir
catchment_area_file = "area/catchment_area.map"

pcr.report(catchment_area, catchment_area_file)

# function for checking if directory exists and otherwise creating it
def check_dir_or_make(path):
    isExist = os.path.exists(path)
    if not isExist:
        # Create a new directory because it does not exist
        os.makedirs(path)

def create_single_timestep_maps(var, input_file):
    check_dir_or_make(var)
    check_dir_or_make(f'{var}/timesteps')
    
    xds = rioxarray.open_rasterio(input_file)
    time = pd.DataFrame(xds[:,0,0].time.to_numpy(), columns=['date'])
    time['date'] = time['date'].astype('str')
    time[['year', 'month', 'left']]= time.date.str.split('-', expand = True)

    for i in range(len(xds[:,0,0])):
        timestep = time.iloc[i,:]
        name = f'{timestep.year}_{timestep.month}'
        print(i+1)
        print(name)
        
        single = f'{var}/timesteps/{var}_{name}'

        cmd = f'cdo seltimestep,{i+1} {input_file} {single}.nc'
        os.system(cmd)

        cmd = f'gdal_translate {single}.nc {single}.tif'
        os.system(cmd)

        cmd = f"gdal_translate -of PCRaster {single}.tif {single}.map"
        os.system(cmd)
    
    os.system(f'rm {var}/timesteps/*.xml')
    os.system(f'rm {var}/timesteps/*.tif')
    os.system(f'rm {var}/timesteps/*.nc')
    
satelliteProducts = ['precipitation']
inputFiles     = ["IMERG_total_precipitation_day_0.5x0.5_global_2000_v6.0.nc"]

for sp in range(len(satelliteProducts)):
    create_single_timestep_maps(satelliteProducts[sp],
                               inputFiles[sp])
