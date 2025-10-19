# Gain Testing
There are two type of gain algorithm, data dependent and data independent. `sugain` is a gain function in Seismic Unix. There are a lot of gain function if you check the manual book. 

## Data Dependent Gain
### Automatic Gain Control (AGC)
First, we'll try data dependent amplitude correction using Automatic Gain Control (AGC). Before visualizing data, AGC is often applied. It means subdividing each trace into windoes with user-specific length. The RMS amplitude within the window is calculated to the samples within the window. AGC is an axample of amplitude information from the data is used to scale it.

To apply AGC to our dataset, the following command is used:
```bash
#!/bin/sh

# Parameter
indata=Line_001_geom.su
ep=32
perc=80

# Take one shot (ep 32)
suwind < $indata key=ep min=$ep max=$ep > ${indata%.su}_ep${ep}.su

# Plot before AGC
suximage < ${indata%.su}_ep${ep}.su perc=$perc title="Plot ep = $ep before AGC" &

# Do AGC
sugain agc=1 < ${indata%.su}_ep${ep}.su > ${indata%.su}_ep${ep}_agc.su

# Plot after AGC
suximage < ${indata%.su}_ep${ep}_agc.su perc=$perc title="Plot ep = $ep after AGC" &

# Apply AGC to dataset
sugain agc=1 < $indata > ${indata%.su}_agc.su
```
The output will loke like this:
![before-after_AGC](../img/img_4.png)
The left image is seismic before AGC and the right image is after AGC is applied.

What about the size of the sub-dividing windows? Isn't the user supposed to supply this piece of information? The reason is in the `sugain` command will use default values if we don't supply any. To see default values, type `sugain` in terminal to see all options:

```bash
 SUGAIN - apply various types of gain

 sugain <stdin >stdout [optional parameters]

 Required parameters:
        none (no-op)

 Optional parameters:
        panel=0         =1  gain whole data set (vs. trace by trace)
        tpow=0.0        multiply data by t^tpow
        epow=0.0        multiply data by exp(epow*t)
        etpow=1.0       multiply data by exp(epow*t^etpow)
        gpow=1.0        take signed gpowth power of scaled data
        agc=0           flag; 1 = do automatic gain control
        gagc=0          flag; 1 = ... with gaussian taper
        wagc=0.5        agc window in seconds (use if agc=1 or gagc=1)
        trap=none       zero any value whose magnitude exceeds trapval
        clip=none       clip any value whose magnitude exceeds clipval
        pclip=none      clip any value greater than clipval
        nclip=none      clip any value less than  clipval
        qclip=1.0       clip by quantile on absolute values on trace
        qbal=0          flag; 1 = balance traces by qclip and scale
        pbal=0          flag; 1 = bal traces by dividing by rms value
        mbal=0          flag; 1 = bal traces by subtracting the mean
        maxbal=0        flag; 1 = balance traces by subtracting the max
        scale=1.0       multiply data by overall scale factor
        norm=0.0        divide data by overall scale factor
        bias=0.0        bias data by adding an overall bias value
        jon=0           flag; 1 means tpow=2, gpow=.5, qclip=.95
        verbose=0       verbose = 1 echoes info
        mark=0          apply gain only to traces with tr.mark=0
                        =1 apply gain only to traces with tr.mark!=0
        vred=0          reducing velocity of data to use with tpow
```

Possible parameters to the `sugain`command are listed, and default values are given. In our case, we have `wagc=1`, which means that the window is 1 seconds long. Try experimenting the window length with other:
```bash
sugain agc=1 wagc=1 < ${indata%.su}_ep${ep}.su | suximage perc=80 &
```

## Data Independent Gain
### $t$ squared
The idea of using $t$ (stands for time) squared is because we are transforming three dimensions to one. The seismic waves are spreading out in three dimensions, and the surface area on the expanding spherical wave increases in proportion to the radius squared. Thus the area on which the energy is distributed is increasing in proportion to time squared. But seismic amplitudes are proportiopnal to the suare root of the energy, so the basic geometry of energy spreading predicts only a single power of time for the spherical divergence correction.

Multiplication by a power of time is a gain function of the form
$$
A_{x} = A_{0} . t^{x}
$$
where $A_{x}$ is amplitude at distance $x$, $A_{0}$ is the original amplitude, $t$ time, and $x$ a scalar. The scalar $x$ would be choosen so that the amplitude is balanced. 

An additional power of $t$ arises from a simple absorption calculation. Absorption requires a model. The model I'll propose is too simple to explain everything about seismic absorption, but it nicely predicts the extra power of $t$ that experience shows we need.
These operations don't permanently after the data, like dependent operations did. If the inverse function is applied to the original data can, in principle, be restored. Using `sugain` command both multiplication by power of time gain can be achieved. The parameters must be given to the `sugain` command is `tpow`.

```bash
#!/bin/sh

# Parameter
indata=Line_001_geom.su
ep=32
perc=80
tpow=2

# Take one shot (ep 32)
suwind < $indata key=ep min=$ep max=$ep > ${indata%.su}_ep${ep}.su

# Plot before tpow
suximage < ${indata%.su}_ep${ep}.su perc=$perc title="Plot ep = $ep before tpow = $tpow" &

# Do tpow
sugain tpow=$tpow < ${indata%.su}_ep${ep}.su > ${indata%.su}_ep${ep}_tpow.su

# Plot after tpow
suximage < ${indata%.su}_ep${ep}_tpow.su perc=$perc title="Plot ep = $ep after tpow = $tpow" &

# Apply tpow to dataset
sugain tpow=$tpow < $indata > ${indata%.su}_tpow.su
```

The output from `tpow = 2` will look like this:
![before-after_tpow](../img/img_5.png)

## QC (Brute Stack)
Here, we generate a brute stack to get a quick look at how the gain functions (`AGC` and `tpow`) shape the seismic data. This QC step helps us see whether the amplitude boost actually improves reflector visibility and overall balance before moving forward.
```bash
#!/bin/sh

killall ximage

# Brute Stack
#indata=Line_001_geom_agc.su               # AGC
indata=Line_001_geom_tpow.su             # tpow
vnmo=1700,2750,3000
tnmo=0.1,1,2

# Add d2
sushw < $indata key=d2 a=0.025 > tmp1

# Sort CDP
susort cdp offset < tmp1 > tmp2

# Apply NMO correction and stacking
sunmo < tmp2 vnmo=$vnmo tnmo=$tnmo | sustack > tmp3

# Plot brute stack
suximage < tmp3 cmap=hsv5 title="Brute stack V0" label1="Time [s]" label2="Offset [km]" perc=90 &

rm -f tmp*
```

This step can actually be shortened by using command piping (`|`) instead of creating temporary files between processes. The brute stack from `tpow` gain appears as follows
![brute_stack-tpow](../img/img_8.png)

## Output Summary

| Step | Description                                  | Output File                  |
| ---- | -------------------------------------------- | ---------------------------- |
| 1    | Extracted single shot (ep = 32)              | `Line_001_geom_ep32.su`      |
| 2    | Single shot after AGC applied                | `Line_001_geom_ep32_agc.su`  |
| 3    | Full dataset after AGC applied               | `Line_001_geom_agc.su`       |
| 4    | Single shot after time-power gain (tpow = 2) | `Line_001_geom_ep32_tpow.su` |
| 5    | Full dataset after time-power gain applied   | `Line_001_geom_tpow.su`      |

## Parameter Summary
> `sugain` using `agc`, `sugain` using `tpow=2`