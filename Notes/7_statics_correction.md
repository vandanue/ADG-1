# Statics Correction
In this section, I show the practical workflow for applying elevation statics and residual statics to the seismic dataset. Elevation statics are normally applied before NMO, but here I apply them after obtaining the best preliminary image. This is acceptable because we can still refine the section later through tighter CMP velocity analysis.

Elevation statics require two key pieces of information: the source and receiver elevations relative to a chosen datum, and the near-surface velocity used to convert elevation differences into travel-time corrections. In this dataset, the source and receiver statics (`selev` and `gelev`) have already been written into the trace headers, which can be verified using `surange`. If these values were not available, they would need to be derived from first-break picks of refracted arrivals.

Elevation statics are applied using:

```bash
sustatic < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat.su hdrs=1
```

Here, `sustatic` applies the correction and `hdrs=1` tells SU to read statics from the headers. Shot gathers before and after the correction show improved timing consistency across offsets. The corrected dataset is then re-sorted to CMP domain using:

```bash
susort cdp offset < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp.su
```

NMO and stacking proceed as usual:

```bash
sunmo par=vpick.data < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp.su | sustack > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2.su
```

Residual statics are handled differently. In SU, the `suresstat` algorithm (following Ronen and Claerbout, 1985) is applied after NMO but still in the shot domain. The data must be resorted by `fldr`:

```bash
susort fldr offset < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_fldr_v2.su
```

Residual statics are then estimated:

```bash
suresstat < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_fldr_v2.su ssol=sstats rsol=rstats ntraces=70782 ntpick=50 niter=5 nshot=481 nr=282 nc=70782 sfold=282 rfold=282 cfold=284
```

This produces source and receiver static files (`sstats` and `rstats`). These corrections are applied via:

```bash
sustatic < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2_resstat.su hdrs=3 sou_file=sstats rec_file=rstats ns=481 nr=1282
```

Finally, the corrected data are stacked:

```bash
sustack < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2_resstat.su > Line_001_stack_v2_resstat.su
```