# Noise Attenuation
Seismic data is packed with all kinds of noise. To clean things up, we use signal enhancement tools both before stacking (prestack) and after stacking (post-stack) the Common Midpoint (CMP) gathers. In these notes, we'll break down how to reduce noise from sesimic data using band-pass filtering, f-k filtering, and deconvolution. We'll also compare when you switch up the order: “gain then filter” vs. “filter then gain.”

## Band-pass Filter
A band-pass filter is a frequency-domain filter that works by multiplying the amplitude spectrum of an input trace with a filter operator. In Seismic Unix, the `sufilter` command is used for this process. It performs zero-phase frequency filtering, meaning the signal’s phase is preserved while its unwanted frequencies are removed. The zero-phase, band-limited wavelet used in the band-pass filter acts as the *filter operator*, shaping the signal to highlight the desired frequency range. In a simple term, band-pass filter is like a vibe check for your seismic data. It only keeps the frequencies that “fit the vibe” and removes the rest. 

The practical aspects is explained in Yilmaz, O. (2001). The goal is to pass a certain bandwidth with little or no modification, and to largely suppress the remaining part of the spectrum as much as practical. At first, it appears that this goal can be met by defining the desired amplitude spectrum for the filter operator as follows:

$$
A(f) = 
\begin{cases}
1, & f_1 < f < f_2; \\
0, & \text{otherwise,}
\end{cases}
$$

Now, let’s get into how this is actually done using the `sufilter` command in Seismic Unix.


```bash
#!/bin/sh

# Band-pass filter

# Parameter
indata=Line_001_geom_tpow.su
f=10,15,70,80                   # Array of filter frequencies (HZ)
amps=0,1,1,0                    # Array of filter amplitudes
perc=80                         
ep=32                           # Shotpoint number

#-------------------------------------------
# Before filter
#-------------------------------------------
# Take one shot
suwind < $indata key=ep min=$ep max=$ep > tmp1

# Plot before filter
suximage < tmp1 perc=$perc title="Shot $ep before bandpass filter" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep before bandpass filter" &

#-------------------------------------------
# After filter
#-------------------------------------------
# Bandpass filter in single shot
sufilter < tmp1 f=$f amps=$amps verbose=1 > tmp2

# Plot after filter
suximage < tmp2 perc=$perc title="Shot $ep after bandpass filter (cutoff = $f)" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep after bandpass filter" &

# Apply band-pass filter to dataset
sufilter < $indata f=$f amps=$amps > ${indata%.su}_bpf.su

rm -f tmp*
```

The image below shows the results of band-pass filter with cut-off frequency 10,15,70,80 in Hz.
![band-pass_filter](../img/img_6.png) 


## F-K Filter


## Deconvolution


## Gain-Filter

## Filter-Gain

### Conclusion

## Output Summary

## Parameter Summary
