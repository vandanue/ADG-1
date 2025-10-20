#!/bin/sh

# Apply d2 (spatial sampling)
# Line_001 data has nominal receiver station interval : 25.00 m

indata=Line_001_geom_cdp_agc.su

sushw < $indata key=d2 a=0.025 > ${indata%.su}_d2.su
