#!/bin/sh

killall ximage
killall xgraph
# Brute stack

indata=Line_001_geom_cdp_agc_d2_fk_bpf_decon.su
vnmo=1700,2750,3000
tnmo=0.1,1,2

# Sort to CMP gather, NMO, stack, and plot
sunmo < $indata vnmo=$vnmo tnmo=$tnmo | sustack > filter_stack.su

suximage < filter_stack.su perc=90 cmap=hsv5 title="Brute stack V0 after FK filter and BPF" label1="Time [s]" label2="Offset (km)" windowtitle="Brute stack" &
