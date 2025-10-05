# Gain Testing

## Objective
Test various gain parameters on a single shot from a shot gather using Seismic Unix (`sugain`). The purpose is display enhancement only; amplitude preservation is required for further processing.

### Workflow

1. **Select Shot**
    - Use `fldr` or `ep` to extract one shot from the gather.
    ```bash
    suwind < data_geom.su key=fldr min=231 max=231 > data_geom-fldr231.su
    ```

2. **Apply Gain**
    - Use `sugain` with different parameters:
      - `tpow`
      - `epow`
      - `agc`
      - etc.
    ```bash
    sugain tpow=2 < data_geom-fldr231.su | suxwigb title='Time power gain' label1='Time [s]' label2='Traces'
    ```

## Note
> Gain testing is for display purposes only. Do **not** use gain-corrected data for amplitude-preserving processing steps.

