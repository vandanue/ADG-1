# Statics Correction
In this section, I show the practical workflow for applying elevation statics and residual statics to the seismic dataset. Elevation statics are normally applied before NMO, but here I apply them after obtaining the best preliminary image. This is acceptable because we can still refine the section later through tighter CMP velocity analysis.

Elevation statics require two key pieces of information: the source and receiver elevations relative to a chosen datum, and the near-surface velocity used to convert elevation differences into travel-time corrections. In this dataset, the source and receiver statics (`selev` and `gelev`) have already been written into the trace headers, which can be verified using `surange`. If these values were not available, they would need to be derived from first-break picks of refracted arrivals.

## Elevation Statics Correction
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

## Residual Statics Correction
Elevation statics corrects the travel-time differences associated with source and receiver elevations relative to a chosen datum. However, near-surface velocity variations can still introduce small timing errors that remain after elevation statics and NMO correction. These errors may cause reflection events to appear misaligned across traces, reducing the coherence of the stacked section.

Residual statics is used to estimate and correct these remaining time shifts. Following Yilmaz, residual statics are estimated from NMO-corrected CMP gathers, where reflection events should ideally be flat. In practice, some events may remain misaligned because the subsurface does not always follow the assumptions used in conventional NMO correction. Near-surface velocity irregularities and lateral velocity variations can produce residual time shifts that make velocity analysis difficult and reduce stacking quality.

The correction is estimated using a *surface-consistent* approach. This means that the time shifts are represented as source- and receiver-dependent terms rather than being estimated independently for every source-receiver pair. The objective is to find a set of static corrections that improves the alignment of reflection events across CMP gathers.

### Estimating Residual Statics

In this workflow, residual statics are estimated after the second-pass velocity analysis and NMO correction. The NMO-corrected data are sorted into the shot domain using `fldr` before running `suresstat`:

```bash
susort fldr offset < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_v2.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_fldr_v2.su
```

Here, `fldr` identifies the field record or shot number, while `offset` orders the traces within each shot gather. Sorting by `fldr` allows the data to be organized by source location for the residual statics estimation workflow.

The residual statics are then estimated using:

```bash
suresstat < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_fldr_v2.su ssol=sstats rsol=rstats ntraces=70782 ntpick=50 niter=5 nshot=481 nr=282 nc=70782 sfold=282 rfold=282 cfold=284
```

The output files, `sstats` and `rstats`, contain the estimated source and receiver static corrections, respectively. These values represent the additional time shifts required to improve reflection alignment after the preliminary velocity analysis and NMO correction.

### Applying Residual Statics

An important distinction in this workflow is that the data used to estimate residual statics are not the same as the data to which the estimated corrections are applied.

According to Yilmaz, residual statics are estimated from NMO-corrected CMP gathers, but the resulting corrections are applied to the original CMP gathers without NMO correction. This distinction matters because residual statics are intended to correct trace timing, while NMO correction compensates for reflection moveout caused by source-receiver offset. Applying the estimated static shifts to the non-NMO-corrected data preserves the moveout information needed for the subsequent velocity analysis and NMO correction.

In Seismic Unix (SU), `suresstat` is run on the NMO-corrected data sorted by `fldr`, whereas `sustatic` applies the estimated corrections to the CMP-sorted data before NMO correction is reapplied. In this workflow, the target dataset is `Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp.su`, which has elevation statics applied but has not yet undergone NMO correction.

The corrections are applied using:

```bash
sustatic < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp.su > Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_resstat.su hdrs=3 sou_file=sstats rec_file=rstats ns=481 nr=1282
```

The `hdrs=3` parameter tells `sustatic` to use the source and receiver static values supplied through `sou_file` and `rec_file`. The corrections are therefore applied to the elevation-statics-corrected CMP gathers without NMO correction, rather than to the NMO-corrected gathers used during estimation.

After applying residual statics, velocity analysis and NMO correction can be repeated to refine the velocity field and improve the alignment of reflection events. The corrected gathers can then be stacked to produce the final seismic section.

For this example, the corrected data are stacked using:

```bash
sustack < Line_001_geom_agc_wagc0.5_d2_fk_bpf15,20,70,80_decon_estat_cdp_resstat.su > Line_001_stack_v2_resstat.su
```

The resulting stack can be inspected using:

```bash
suximage perc=90 title="Line_001 stack v2 after residual statics" label1="TWT [s]" label2="CDP" cmap=hsv4 < Line_001_stack_v2_resstat.su &
```

![stack-after-resstat](../../img/img_14.png)

The main purpose of residual statics is to improve the temporal alignment and continuity of reflection events, especially in areas affected by near-surface irregularities. Better alignment generally improves the coherence of the stacked reflections. However, residual statics should not be expected to compensate for every type of velocity-model error or structural complexity.