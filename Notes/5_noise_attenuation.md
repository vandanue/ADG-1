# Noise Attenuation
Seismic data is packed with all kinds of noise. To clean things up, we use signal enhancement tools both before stacking (prestack) and after stacking (post-stack) the Common Midpoint (CMP) gathers. 

Table below gives example of common observed types of noise that can contribute to the seismic data.
|Coherent Noise|Ambient Noise|
|--------------|-------------|
| Ground roll | Recording equipment |
| Direct wave | Bad geophone coupling |
| Reverberation | Spikes |
| Ship noise | Weather/wind |
| Rig noise | Swell noise |
| Rig diffraction | Vehicles |
| Power lines | Animals |

In these notes, we'll break down how to reduce noise from sesimic data using band-pass filtering, f-k filtering, and deconvolution. We'll also compare when you switch up the order: “gain then filter” vs. “filter then gain.”

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

killall ximage
killall xgraph

# Bandpass filter

# Parameter
indata=Line_001_geom_tpow_d2_fk.su
f=10,15,70,80
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
```

The image below shows the result of the band-pass filter with cut-off frequencies of 10, 15, 70, and 80 Hz. Most of the ground-roll energy is removed after applying the filter. Increasing the low-cut frequency can further reduce noise, but it should be done carefully since it may also remove parts of the useful signal that share similar frequencies.
![band-pass_filter](../img/img_6.png) 

## F-K Filter


## Deconvolution
Deconvolution compresses the basic wavelet in the recorded seismogram, attenuates reverberations and short-period multiples, and improves temporal resolution, giving a clearer representation of subsurface reflectivity. Beyond simple wavelet compression, deconvolution also helps suppress multiple energy in the seismic section. This process is commonly implemented using an inverse filter as the deconvolution operator, which ideally recovers the earth's impulse response when applied to a seismogram. The inverse filter is typically estimated using the least-squares method.

Mathematically, this can be expressed as:
$$
x(t) = w(t) * r(t) + n(t)
$$

where $r(t)$ is the recorded trace, $w(t)$ is the source wavelet, $r(t)$ is the reflectivity, and $n(t)$ is noise. Deconvolution aims to recover $r(t)$ by minimizing the wavelet effect through inverse filtering.

In practice, deconvolution in Seismic Unix can be performed using the `supef` command, which applies predictive deconvolution to enhance resolution and reduce short-period multiples.

```bash
#!/bin/sh
#!/bin/sh

killall ximage

# Deconvolution

# Parameter
indata=Line_001_geom_tpow_d2_fk_bpf.su
ep=32
perc=80
minlag=0.02
maxlag=0.1
pnoise=0.001
ntout=120

#-------------------------------------------
#----------- Before deconvolution ----------
#-------------------------------------------
# Take one shot
suwind < $indata key=ep min=$ep max=$ep > tmp1

# Plot before deconvolution
suximage < tmp1 perc=$perc title="Shot $ep before deconvolution" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep before deconvolution" &

# Autocorrelation before deconvolution
suacor < tmp1 ntout=$ntout | suximage perc=$perc title="Autocorrelation before deconvolution" windowtitle="Autocorrelation"&

#-------------------------------------------
#----------- After deconvolution ----------
#-------------------------------------------
# Deconvolution
supef < tmp1 > tmp2 minlag=$minlag maxlag=$maxlag pnoise=$pnoise

# Plot after deconvolution
suximage < tmp2 perc=$perc title="Shot $ep after deconvolution" label1="TWT [s]" label2="Trace" windowtitle="Shot $ep after deconvolution" &

# Autocorrelation after deconvolution
suacor < tmp2 ntout=$ntout | suximage perc=$perc title="Autocorrelation after deconvolution" windowtitle="Autocorrelation" &

# Deconvolution to dataset
supef < $indata > ${indata%.su}_decon.su minlag=$minlag maxlag=$maxlag pnoise=$pnoise

rm -f tmp*
```

## Gain-Filter

## Filter-Gain

### Conclusion

## Output Summary

## Parameter Summary
