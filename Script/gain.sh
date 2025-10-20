#!/bin/sh

killall ximage
# Gain tesing with various parameter

# Parameter
indata=Line_001_geom_cdp.su
ep=32
perc=80
tpow=2

# Take one shot (ep 32)
suwind < $indata key=ep min=$ep max=$ep > tmp1

# Plot before AGC
suximage < tmp1 perc=$perc title="Plot ep = $ep before gain" label1="TWT [s]" label2="Trace" windowtitle="Raw data"&

# Do AGC
sugain agc=1 wagc=1 < tmp1 > tmp2

# Plot after AGC
suximage < tmp2 perc=$perc title="Plot ep = $ep after AGC" label1="TWT [s]" label2="Trace" windowtitle="AGC" &

# Do tpow
sugain tpow=$tpow < tmp1 > tmp3

# Plot after tpow
suximage < tmp3 perc=$perc title="Plot ep = $ep after tpow = $tpow" label1="TWT [s]" label2="Trace" windowtitle="Time power gain" &

# Apply gain to dataset
sugain agc=1 wagc=0.2 < $indata > ${indata%.su}_agc.su

rm -f tmp*
