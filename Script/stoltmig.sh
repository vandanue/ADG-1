#!/bin/sh

indata=Line_001_v1_resstat_stack_mute.su
outdata=Line_001_PoSTM.su

tmig=0.0187891,0.494781,0.914405,1.37787,1.94781,2.90605 
vmig=1992.35,2211.92,2488.77,2765.61,2975.64,3319.31
smig=0.6
vscale=1
lstaper=50
lbtaper=50

cdpmin=1
cdpmax=1282
dxcdp=50


# Migration
sustolt < $indata > $outdata cdpmin=$cdpmin cdpmax=$cdpmax dxcdp=$dxcdp tmig=$tmig vmig=$vmig smig=$smig vscale=$vscale lstaper=$lstaper lbtaper=$lbtaper

# Plot migration
suximage < $outdata title="Post-stack stolt migration" perc=90 cmap=hsv4 label1="TWT [s]" label2="CDP" &
