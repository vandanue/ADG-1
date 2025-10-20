#!/bin/sh

killall ximage
killall xwigb

# Deconvolution

# Parameter
indata=Line_001_geom_cdp_agc_d2_fk_bpf.su
ep=150
perc=95
minlag=0.02
maxlag=0.1
pnoise=0.001
ntout=120

#-------------------------------------------
#----------- Before deconvolution ----------
#-------------------------------------------
# Take one shot
suwind < $indata key=ep min=$ep max=$ep | sunmo vnmo=2900 > tmp1
#suwind < $indata key=ep min=$ep max=$ep > tmp1
#-------------------------------------------
# Plot before deconvolution
#-------------------------------------------
suximage < tmp1 perc=$perc title="Shot $ep before deconvolution" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep before deconvolution" &
#-------------------------------------------
# Autocorrelation before deconvolution
#-------------------------------------------
suacor < tmp1 suacor ntout=$ntout | suxwigb perc=100 title="Autocorrelation before deconvolution" label1="TWT [s]" label2="Offset [m]" key=offset windowtitle="Autocorrelation" &

#-------------------------------------------
#----------- After deconvolution ----------
#-------------------------------------------
# Deconvolution
supef < tmp1 minlag=$minlag maxlag=$maxlag pnoise=$pnoise > tmp2 
#-------------------------------------------
# Plot after deconvolution
#-------------------------------------------
suximage < tmp2 perc=$perc title="Shot $ep after deconvolution" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep after deconvolution" &
#-------------------------------------------
# Autocorrelation after deconvolution
#-------------------------------------------
suacor < tmp2 suacor ntout=$ntout | suxwigb perc=100 title="Autocorrelation after deconvolution" label1="TWT [s]" label2="Offset [m]" key=offset windowtitle="Autocorrelation" &

#-------------------------------------------
# Apply deconvolution
#-------------------------------------------
supef < $indata minlag=$minlag maxlag=$maxlag pnoise=$pnoise > ${indata%.su}_decon.su 

rm -f tmp*
