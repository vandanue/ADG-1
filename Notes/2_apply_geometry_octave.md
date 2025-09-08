# Apply Geometry for 2D Land Seismic Data using MATLAB/Octave

Applying geometry is a big deal in seismic processing. You can run this step either before or after other processes (like filtering), it really depends on the workflow you’re going for. These notes give you a quick walkthrough on how to apply geometry to 2D seismic data using MATLAB/Octave.

Tbh, I usually go with Octave instead of MATLAB because it’s free (no need to cry over MATLAB licenses ^_^) and super easy to install:

```bash
sudo apt-get update
sudo apt install octave
```

## Step 1 – Extracting Source and Receiver Information (SPS & RPS Files)

So, before we can even think about processing seismic data, we gotta know where stuff actually is in the field. That’s where the geometry step comes in. In plain terms: each trace needs to know exactly where the source and receiver were in the field. That’s the whole point of the SPS (source) and RPS (receiver) files.

The raw data for this lives in the SEG positioning files:

- SPS file = “where the shots were fired” (source ID, coordinates, elevation, statics).

- RPS file = “where the geophones were planted” (receiver ID, coordinates, elevation, statics).

These files come with a long header that describes each column, but SU doesn’t need all that extra fluff, so just the numbers we care about.

### Example SPS chunk

```nginx
SLINE_001             7011V1 -50 0.0   0 0 0.0 688081.8 3838302.1  46.0  0 0 0 0
SLINE_001             7031V1 -50 0.0   0 0 0.0 688130.6 3838314.5  46.0  0 0 0 0
SLINE_001             7051V1 -51 0.0   0 0 0.0 688180.1 3838321.8  46.0  0 0 0 0
```

From this, we’ll eventually use:

1. Point number (ID) → e.g. 7011V1

2. Easting (X) and Northing (Y)

3. Elevation

4. Static correction

### Pre-cleaning with `awk`

To get these into a format SU can actually digest, we first use a small shell script ([what is shell scripting?]([Introduction to Linux Shell and Shell Scripting - GeeksforGeeks](https://www.geeksforgeeks.org/linux-unix/introduction-linux-shell-shell-scripting/))). This script trims the header and pulls only the useful columns.

```shell
awk 'gsub(/1V1/,""){if(NR>20){print$2,$8,$9,$10,$3}}' Line_001.SPS > SPS_extract.txt
```

- `NR>20` will skip the first 20 header lines

- `gsub(/1V1/,"")` cleaning up the source IDs (remove the "1V1")

- `print $2,$8,$9,$10,$3` grab source ID, X, Y, elevation, and static

- Then, save it all into `SPS_extract.txt` using redirect out (>)

The same process for RPS, but for receivers: clean the IDs, pull out the essentials, save to `RPS_extract.txt`.

SU doesn’t want to deal with messy SPS/RPS formats directly. What it does want is clean ASCII files that can be read later into SU programs like `sushw`. These clean files will let us:

- Insert geometry headers into the traces (CDP, offset, source/receiver coords).

- Plot shot/receiver layouts (`pswigb`, etc)

- Build gathers for later processing.

Basically: we’re prepping the geometry metadata so SU can “link” traces to the field survey.

## Step 2 – Building the Geometry Matrix in MATLAB/Octave

Okay, so after Step 1 we’ve got our clean SPS and RPS extract files. Now it’s time to actually build the geometry header matrix, which basically tells us: 

- Where the source (sx, sy, selev, sstat) is for each trace

- Where the receiver (gx, gy, gelev, gstat) is for each trace

- The offset (distance between source and receiver)

- The CDP (Common Depth Point) number for stacking later

The script can be accessed in this [repository]([ADG-1/Scripts/1_geometry/matlab-octave at 192ab28266fb8a46be2af1985d7ac2a82e8a7d57 · vandanue/ADG-1 · GitHub](https://github.com/vandanue/ADG-1/tree/192ab28266fb8a46be2af1985d7ac2a82e8a7d57/Scripts/1_geometry/matlab-octave)) 

### Loading the SPS & RPS data

```matlab
load SPS_extract.txt
load RPS_extract.txt
```

Simple: bring in the cleaned files we made in Step 1.

### Expanding SPS for all traces

```matlab
for i=1:251
    sps_for_traces_in_each_shot{i}=repmat(SPS_extract(i,:),282,1);
end
sps_all_traces=cell2mat(sps_for_traces_in_each_shot');
```

- We had 251 shots, each one connected to 282 receivers.

- So we “repeat” each source row 282 times using `repmat` to match with every receiver.

- Result: `sps_all_traces` = one big list of source info for all 70,782 traces.

### Expanding RPS for all traces

```matlab
for i=1:251
    rps_for_traces_in_each_shot{i}=RPS_extract([(i*2)-1:281+(i*2)-1]',:);
end
rps_all_traces=cell2mat(rps_for_traces_in_each_shot');
```

- Each shot is paired with the right sequence of 282 receivers from the RPS file.

- Loop over 251 shots, slice the right part of `RPS_extract`, and stick them together.

- Result: `rps_all_traces` = receiver info for all traces.

### Calculating offset (source–receiver distance)

```matlab
sx=sps_all_traces(:,2); sy=sps_all_traces(:,3);
gx=rps_all_traces(:,2); gy=rps_all_traces(:,3);

ox=gx-sx; oy=gy-sy;
offset=sqrt(ox.^2+oy.^2);
```

Offset = basically the 2D distance between source and receiver. This number is super important later for velocity analysis, moveout correction, and stacking.

### Assigning CDP numbers

```matlab
for i=1:251
    cdp_each_shot{i}=[(4*i-3):281+(4*i-3)]';
end
cdp_all_traces=cell2mat(cdp_each_shot');
```

The survey had:

- Source interval = 50 m

- Receiver interval = 25 m

So each new shot shifts the CDPs by 4 (because 50 ÷ 25 = 2, doubled for midpoint shift).

- Shot 1 > CDP 1 to 282

- Shot 2 > CDP 5 to 286

- Shot 3 > CDP 9 to 290

- ... and so on

This matches the stacking diagram logic you’d see in geometry design.

### Building and saving the header matrix

```matlab
geom_header=[sx,sy,selev,sstat,gx,gy,gelev,gstat,cdp_all_traces,offset];
save -ascii geom_header.txt geom_header
```

Now we’ve got a geometry header matrix with columns:

1. Source X (sx)

2. Source Y (sy)

3. Source Elevation

4. Source Static

5. Receiver X (gx)

6. Receiver Y (gy)

7. Receiver Elevation

8. Receiver Static

9. CDP number

10. Offset

### Quick Plot of Source–Receiver Layout

```matlab
plot(sx,sy,'r*'); hold on
plot(gx,gy,'b^');
xlabel('Easting'); ylabel('Northing');
legend('Source','Geophone');
title("Source Receiver Plot")
```

Red stars = sources, blue triangles = receivers. This quick plot is a sanity check, if the geometry looks weird here, it’s gonna be chaos later in SU.

## Step 3 – Offset Regularization

So after we built the geometry header matrix, we noticed something:

- The CDP numbers looked fine (they run nicely from 1 to 1282)

- But the offset values were messy. Instead of a clean sequence like 25, 50, 75, ..., they had weird variations (3518, 3509, ...)

Why? Because in real-life field acquisition, the source and receiver coordinates are never perfectly on-grid. Small shifts (like crooked lines, uneven terrain, GPS errors, or manual planting of geophones) create irregular offsets. This irregularity is natural in the field, but it makes processing harder. A lot of seismic processing steps (like velocity analysis, NMO correction, stacking) work better if offsets are regularized (snapped to neat intervals).

### The theory in simple terms

- Offset = distance between source and receiver.

- In the field → offset is continuous (any value, slightly messy).

- For processing → we want offset to be discrete (e.g., multiples of 25 m).

This process of snapping the messy offsets into clean bins (e.g., 25, 50, 75, ...) is called offset regularization. You can think of it like taking noisy GPS coordinates and snapping them to the nearest grid on Google Maps.

### What the code does

```matlab
right=[25:25:3525]';
left=[-3525:25:-25]';
offset_each_shot=[left;right];
offset_all_shot=repmat(offset_each_shot,251,1);
```

Creates a regular offset vector:

- Negative offsets = receivers to the left of source

- Positive offsets = receivers to the right of source

- Interval = 25 m

- Max = 3525 m (since we had 282 receivers per shot).

Then repeat `repmat` this pattern for all 251 shots, so we have a full regular offset sequence for all 70k+ traces.

```matlab
load geom_header.txt
geom_header_reg_offset=[geom_header(:,[1:9]),offset_all_shot];
save -ascii geom_header_reg_offset.txt geom_header_reg_offset
```

Replace the messy field offsets in `geom_header.txt` with our new regularized offsets. Save it as `geom_header_reg_offset.txt`. 

TL;DR: Field offsets are messy (like GPS scatter). Offset regularization snaps them into neat bins (like a clean grid). This makes the processing pipeline much smoother, especially for CDP gathers and velocity analysis.

## Geometry Recap

The workflow has 3 steps, all available in my GitHub repo: 

- Step 1 - `extract_geom_ps`

- Step 2 - `geom_octave.m`

- Step 3 - `regoff.m`
