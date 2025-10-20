#!/bin/sh

killall ximage
killall xgraph
# FK filter

# Parameter
DIR=../2_gain_test
indata=Line_001_geom.su
dt=0.002
dx=0.025
ep=32
perc=80

slopes=-0.5,-0.3,0.3,0.5
amps=0,1,1,0
bias=0

#-------------------------------------------
#--------------- Before filter -------------
#-------------------------------------------
# Take one shot (i.e. use ep)
suwind < $indata key=ep min=$ep max=$ep > tmp1

# Plot before FK
suximage < tmp1 perc=$perc title="Shot $ep before FK filter" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep before filter" &

# Plot FK spectrum before filter
suspecfk < tmp1 dt=$dt dx=$dx | suximage cmap=hsv2 x1end=120 legend=1 title="FK spectrum before filter" label1="Frequecy [Hz]" label2="Wavenumber [1/km]" windowtitle="FK spectrum before filter" &

#-------------------------------------------
#-------------- After filter ---------------
#-------------------------------------------
# FK filter in single shot
sudipfilt < tmp1 dt=$dt dx=$dx slopes=$slopes amps=$amps bias=$bias > tmp2

# Plot after FK
suximage < tmp2 perc=$perc title="Shot $ep after FK filter" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep after filter" &

# Plot FK spectrum after filter
suspecfk < tmp2 dt=$dt dx=$dx | suximage cmap=hsv2 x1end=120 legend=1 title="FK spectrum after filter" label1="Frequecy [Hz]" label2="Wavenumber [1/km]" windowtitle="FK spectrum after filter" &

#-------------------------------------------
# Apply FK
#-------------------------------------------
sudipfilt < ${DIR}/${indata} dt=$dt dx=$dx slopes=$slopes amps=$amps bias=$bias > ${indata%.su}_fk.su

rm -f tmp*
