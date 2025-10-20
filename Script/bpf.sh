#!/bin/sh

killall ximage
killall xgraph

# Bandpass filter

# Parameter
indata=Line_001_geom_cdp_agc_d2_fk.su
f=10,15,55,60
amps=0,1,1,0
perc=80
ep=32
trace_min=3
trace_max=5

#-------------------------------------------
#--------------- Before filter -------------
#-------------------------------------------
# Take one shot
suwind < $indata key=ep min=$ep max=$ep > tmp1

# Plot before filter
suximage < tmp1 perc=$perc title="Shot $ep before bandpass filter" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep before bandpass filter" &
#-------------------------------------------
# Plot Gabor spectrogram (instantanous frequency)
#-------------------------------------------
# Take a few trace
suwind < tmp1 key=offset min=-50 max=50 | sustack key=dt | sugabor fmax=125 band=6 | suximage xbox=990 ybox=5 wbox=330 hbox=470 cmap=hsv6 x2end=150 legend=1 label1="TWT [s]" label2="Frequency [Hz]" title="Frequency spectrum (near offset) before filter" windowtitle="Gabor spectrogram" &
#-------------------------------------------
# Plot frequency spectrum
#-------------------------------------------
suwind < tmp1 key=tracf min=$trace_min max=$trace_max | sufft | suamp mode=amp | suop op=db | suxgraph style=normal -geometry 330x200+665+510 x1end=250 grid1=dot grid2=dot title="Amplitude spectrum before filter" label1="Frequency [Hz]" label2="Amplitude [dB]" windowtitle="Frequency spectrum" &

#-------------------------------------------
#-------------- After filter ---------------
#-------------------------------------------
# Bandpass filter in single shot
sufilter < tmp1 f=$f amps=$amps verbose=1 > tmp2

# Plot after filter
suximage < tmp2 perc=$perc title="Shot $ep after bandpass filter (cutoff = $f)" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep after bandpass filter" &
#-------------------------------------------
# Plot Gabor spectrogram (instantanous frequency)
#-------------------------------------------
# Take a few trace
suwind < tmp2 kkey=offset min=-50 max=50 | sustack key=dt | sugabor fmax=125 band=6 | suximage xbox=990 ybox=5 wbox=330 hbox=470 cmap=hsv6 x2end=150 legend=1 label1="TWT [s]" label2="Frequency [Hz]" title="Frequency spectrum (near offset) after filter" windowtitle="Gabor spectrogram" &
#-------------------------------------------
# Plot frequency spectrum
#-------------------------------------------
suwind < tmp2 key=tracf min=$trace_min max=$trace_max | sufft | suamp mode=amp | suop op=db | suxgraph style=normal -geometry 330x200+665+510 x1end=250 grid1=dot grid2=dot title="Amplitude spectrum after filter (cutoff = $f)" label1="Frequency [Hz]" label2="Amplitude [dB]" windowtitle="Frequency spectrum" &

#-------------------------------------------
# Apply BPF
#-------------------------------------------
sufilter < $indata f=$f amps=$amps verbose=1 > ${indata%.su}_bpf.su

rm -f tmp*
