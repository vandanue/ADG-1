import os
import math
import csv 
import numpy as np
from matplotlib import pyplot as plt

os.chdir(r'D:\ADG\Data\1_geometry\python')
fname1 = 'Line_001.SPS'
fname2 = 'Line_001.RPS'
fname3 = 'Line_001.XPS'

## Read sps, rps, and xps
## Source
fhand = open(fname1)
sp = []; sx = []; sy = []; selev = []; sstat = []
for line in fhand:
    if not line.startswith('H26'):
        sp.append(line[17:25]); sx.append(line[46:55]); sy.append(line[55:65]); selev.append(line[65:71]); sstat.append(line[28:32])
# strip white space
sp = [i.strip(' ') for i in sp]; sx = [i.strip(' ') for i in sx]; sy = [i.strip(' ') for i in sy]; selev = [i.strip(' ') for i in selev]; sstat = [i.strip(' ') for i in sstat]
# convert data type to int
sp_int = []; sx_int = []; sy_int = []; selev_int = []; sstat_int = []
for i in sp:
    x = int(i); sp_int.append(x)
for i in sx:
    x = float(i); sx_int.append(x)
for i in sy:
    x = float(i); sy_int.append(x)
for i in selev:
    x = float(i); selev_int.append(x)
for i in sstat:
    x = float(i); sstat_int.append(x)
s_params = {'sp': sp_int, 'sx': sx_int, 'sy': sy_int, 'selev': selev_int, 'sstat': sstat_int}
sx_params = {sp_int[i]:sx_int[i] for i in range(0,np.shape(sp_int)[0])}
sy_params = {sp_int[i]:sy_int[i] for i in range(0,np.shape(sp_int)[0])}
selev_params = {sp_int[i]:selev_int[i] for i in range(0,np.shape(sp_int)[0])}
sstat_params = {sp_int[i]:sstat_int[i] for i in range(0,np.shape(sp_int)[0])}

## Receiver
fhand = open(fname2)
rp = []; rx = []; ry = []; relev = []; rstat = []
for line in fhand:
    if not line.startswith('H26'):
        rp.append(line[17:25]); rx.append(line[46:55]); ry.append(line[55:65]); relev.append(line[65:71]); rstat.append(line[28:32])
# strip white space
rp = [i.strip(' ') for i in rp]; rx = [i.strip(' ') for i in rx]; ry = [i.strip(' ') for i in ry]; relev = [i.strip(' ') for i in relev]; rstat = [i.strip(' ') for i in rstat]
# convert data type to int
rp_int = []; rx_int = []; ry_int = []; relev_int = []; rstat_int = []
for i in rp:
    x = int(i); rp_int.append(x)
for i in rx:
    x = float(i); rx_int.append(x)
for i in ry:
    x = float(i); ry_int.append(x)
for i in relev:
    x = float(i); relev_int.append(x)
for i in rstat:
    x = float(i); rstat_int.append(x)
r_params = {'rp': rp_int, 'rx': rx_int, 'ry': ry_int, 'relev': relev_int, 'rstat': rstat_int}
rx_params = {rp_int[i]:rx_int[i] for i in range(0,np.shape(rp_int)[0])}
ry_params = {rp_int[i]:ry_int[i] for i in range(0,np.shape(rp_int)[0])}
relev_params = {rp_int[i]:relev_int[i] for i in range(0,np.shape(rp_int)[0])}
rstat_params = {rp_int[i]:rstat_int[i] for i in range(0,np.shape(rp_int)[0])}

## SR Relation 
fhand = open(fname3)
xp = []; r1 = []; r2 = []
for line in fhand:
    if not line.startswith('H26'):
        xp.append(line[29:37]); r1.append(line[63:71]); r2.append(line[71:79])
# strip white space
xp = [i.strip(' ') for i in xp]; r1 = [i.strip(' ') for i in r1]; r2 = [i.strip(' ') for i in r2]
# convert data type to int
xp_int = []; r1_int = []; r2_int = []
for i in xp:
    x = int(i); xp_int.append(x)
for i in r1:
    x = float(i); r1_int.append(x)
for i in r2:
    x = float(i); r2_int.append(x)
x_params = {'xp': xp_int, 'r1': r1_int, 'r2': r2_int}
x_params2 = {int(xp_int[i]):[*range(int(r1_int[i]),int(r2_int[i])+1)] for i in range(0,np.shape(xp_int)[0])}

## Calculate Offset
offset=[]; sxcoor=[]; sycoor=[]; rxcoor=[]; rycoor=[]; s_elev=[]; r_elev=[]; s_stat=[]; r_stat=[]; tracl=[]; temp=0;
for i in range(0, np.shape(xp_int)[0]):
    tracl_temp = temp
    for j in range(0,282): #282 is number of channels active per shot
        if (int(x_params['xp'][i]) in sp_int and int(x_params['r1'][i]) in rp_int and int(x_params['r2'][i]) in rp_int):
            sxcoor_temp = sx_params[(x_params['xp'][i])]
            sycoor_temp = sy_params[(x_params['xp'][i])]
            s_elev_temp = selev_params[(x_params['xp'][i])]
            s_stat_temp = sstat_params[(x_params['xp'][i])]
            #
            rxcoor_temp = rx_params[x_params2[(x_params['xp'][i])][j]]
            rycoor_temp = ry_params[x_params2[(x_params['xp'][i])][j]]
            r_elev_temp = relev_params[x_params2[(x_params['xp'][i])][j]]
            r_stat_temp = rstat_params[x_params2[(x_params['xp'][i])][j]]
            #
            tracl_temp = temp + j + 3
            #
            offset_temp = math.sqrt((rxcoor_temp - sxcoor_temp)**2 + (rycoor_temp - sycoor_temp)**2)
            
            if (x_params['xp'][i] >  x_params2[(x_params['xp'][i])][j]):
                offset_temp = offset_temp * -1

            offset.append(offset_temp)
            sxcoor.append(sxcoor_temp)
            sycoor.append(sycoor_temp)
            rxcoor.append(rxcoor_temp)
            rycoor.append(rycoor_temp)
            s_elev.append(s_elev_temp)
            r_elev.append(r_elev_temp)
            s_stat.append(s_stat_temp)
            r_stat.append(r_stat_temp)
            tracl.append(tracl_temp)      
    temp = tracl_temp

# Calculate CDP
cdp_each_shot = []
for i in range(1, 252):                         # Number of shot +1
    start = 4 * i - 3                           
    end = 281 + (4 * i - 3)                     # Number of active receiver -1
    cdp_each_shot.extend(range(start, end + 1))

# Offset regularization
right = np.arange(25, 3525 + 1, 25)  
left = np.arange(-3525, -25 + 1, 25) 
offset_each_shot = np.concatenate((left, right))
offset_each_shot = np.tile(offset_each_shot, 251).reshape(-1, 1).flatten().tolist()

import collections
# count each CDP
cdp_counts = collections.Counter(cdp_each_shot)
# sort CDP number
cdp_numbers = sorted(cdp_counts.keys())
fold_values = [cdp_counts[i] for i in cdp_numbers]
# plot
plt.figure(figsize=(12,6))
plt.plot(cdp_numbers, fold_values, color="b")
plt.xlabel("CDP number", fontsize=14)
plt.ylabel("Fold", fontsize=14)
plt.title("Fold coverage", fontsize=16, fontweight="bold")
plt.grid(True)
plt.show()

# Offset compare
plt.figure(figsize=(12,6))
plt.subplot(1,2,1)
plt.hist(offset, bins=100, color='b', edgecolor='black')
plt.xlabel('Offset (m)', fontsize=14)
plt.ylabel('Count', fontsize=14)
plt.title('Before Regularization', fontsize=16, fontweight="bold")

plt.subplot(1,2,2)
plt.hist(offset_each_shot, bins=100, color='r', edgecolor='black')
plt.xlabel('Offset (m)', fontsize=14)
plt.ylabel('Count', fontsize=14)
plt.title('After Regularization', fontsize=16, fontweight="bold")
plt.show()

# Save using pandas
import pandas as pd

geom_df = pd.DataFrame({
    'sx': sxcoor,
    'sy': sycoor,
    'selev': s_elev,
    'sstat': s_stat,
    'gx': rxcoor,
    'gy': rycoor,
    'gelev': r_elev,
    'gstat': r_stat,
    'cdp': cdp_each_shot,
    'offset': offset_each_shot,
    'tracl': tracl,
    'tracr': tracl
})

geom_df.to_csv('geometry.txt', sep=' ', index=False, header=False)

# Source & Receiver Locations
fig1=plt.figure(1, figsize=(12, 10))
plt.plot(sxcoor, sycoor, color='r', markersize=7)
plt.scatter(rxcoor, rycoor, color='b', s=3)
plt.tick_params(axis="x", labelsize=18) 
plt.tick_params(axis="y", labelsize=18)
plt.xlabel('Easting', fontsize=23, fontweight='bold')
plt.ylabel('Northing', fontsize=23, fontweight='bold')
plt.title('Source & Receiver Location',fontsize=30, fontweight='bold')
plt.show()

## CDP & Offset
fig3=plt.figure(1, figsize=(12, 10))
plt.scatter(cdp_each_shot, offset, color='b', s=3)
plt.tick_params(axis="x", labelsize=18) 
plt.tick_params(axis="y", labelsize=18)
plt.xlabel('CDP', fontsize=23, fontweight='bold')
plt.ylabel('Offset', fontsize=23, fontweight='bold')
plt.title('Stacking Chart',fontsize=30, fontweight='bold')
plt.show()