# Apply Geometry for 2D Land Seismic Data using Python

These notes cover how to apply geometry on 2D land seismic data. I already did a version in MATLAB/Octave, but here I’m also showing how to do it in Python. You can run the workflow either in Jupyter Notebook or Spyder, depending on what’s comfy. All scripts for applying geometry are available in this repo as both `.ipynb` and `.py` files. 

## (Optional) Setup for Python Environment

If you’re on Windows with Anaconda/Miniconda, you probably already have Spyder or Jupyter Notebook installed. But if not, here’s the quick setup:

- Install Jupyter Notebook

```bash
sudo apt install jupyter-notebook jupyter-core python3-ipykernel
```

Run it with:

```bash
jupyter notebook
```

- Install Spyder

```bash
sudo apt update
sudo apt install spyder
```

Launch it with:

```bash
spyder
```

If you’re running the scripts in Jupyter Notebook, use the `.ipynb` version. If you’re working in Spyder (or any Python IDE), use the `.py` version.

## Step 1 – Checking SPS, RPS, and XPS Files

Before applying geometry, we need to take a quick look at the raw navigation files:

- SPS → Source Point file (shots)

- RPS → Receiver Point file (geophones)

- XPS → Cross-reference file (shot–receiver relationship)

I wrote a script called `sps_check.ipynb`  that parses those files and prints out useful info like:

- First & last shot point, plus total number of shots

- First & last receiver point, plus total number of receivers

- Field file IDs and total trace count from XPS

This step helps confirm that the survey geometry makes sense before we build the header matrix.

The program output the following information:

```py
============= SPS FILE=============
First Shot Point:       701
Last Shot Point:      1201
Total number of shots:  251 VPs
============= RPS FILE=============
First Receiver Point:       561
Last Shot Point:      1342
Total number of receivers:  782 Receiver
============= XPS FILE=============
First Field File ID:   231
Last Field File ID:   481
Total number of traces:  70782
```

The output of total number of shots and receivers will be used as input in the next step.

## Step 2 – Process the Geometry

Goal: build a per-trace geometry table with `[sx, sy, s_elev, s_stat, gx, gy, g_elev, g_stat, offset]` that matches the survey (shots × receivers) and save it as `geometry.txt`.

### Point to the data + basic inputs

1. Change to the survey folder and set filenames:

2. Ask for counts:
   
   - `Enter total number of Shots`
   
   - `Enter total number of Receivers`

> Note: in the script the variables are named `nrcv`/`nsrc` but used as shots/receivers. They’re just prompts, not used later.

### Parse SPS (sources)

1. Read each non-header (`not line.startswith('H26')`) line.

2. Slice fixed-width fields (0-based, end-exclusive):
   
   - `line[17:25]` → SP id
   
   - `line[46:55]` → sx (easting)
   
   - `line[55:65]` → sy (northing)
   
   - `line[65:71]` → source elevation
   
   - `line[28:32]` → source static

3. Strip whitespace per field, cast:
   
   - ids → `int`, coords/elev/statics → `float`/`int`

4. Build quick lookup dicts keyed by SP id:
   
   - `dict_sx[sp] = sx`, `dict_sy[sp] = sy`, `dict_selev[sp] = elev`, `dict_sstat[sp] = stat`

### Parse RPS (receivers)

1. Same idea, slice:
   
   - `line[17:25]` → RP id
   
   - `line[46:55]` → rx
   
   - `line[55:65]` → ry
   
   - `line[65:71]` → receiver elevation
   
   - `line[28:32]` → receiver static

2. Cast and build dicts keyed by RP id:
   
   - `dict_rx[rp] = rx`, `dict_ry[rp] = ry`, `dict_relev[rp] = elev`, `dict_rstat[rp] = stat`

### Parse XPS (shot–receiver relation)

1. XPS ties each VP (shot) to a channel range (first to last receiver).

2. Slice:
   
   - `line[29:37]` → vp id
   
   - `line[63:71]` → channel_from
   
   - `line[71:79]` → channel_to

3. Clean/cast, then expand each VP’s channel range:
   
   - `dict_xps2[vp] = list(range(ch_from, ch_to + 1))`

### Build trace-by-trace geometry + offset

For each VP `i` and each channel `j` in its range:

1. Look up receiver by channel id: `rx`, `ry`, `r_elev`, `r_stat`

2. Look up source by VP id: `sx`, `sy`, `s_elev`, `s_stat`

3. Compute offset (Euclidean distance):
   
   $$
   offset = \sqrt{(rx - sx)^2 + (ry - sy)^2}
   $$
   
   - `ox = xcor_r - xcor_s; oy = ycor_r - ycor_s; offs = math.sqrt(ox*ox + oy*oy)` in the code

4. Apply a sign convention (left/right):
   
   - If `vp > receiver_id`, set `offs = -offs` (so offsets can be ±)

Append to lists:

`xcord_s, ycord_s, src_elev, src_stat, xcord_r, ycord_r, rcv_elev, rcv_stat, offset`

### Write out `geometry.txt`

Save one row per trace:

```py
sx  sy  s_elev  s_stat  gx  gy  g_elev  g_stat  offset
```

This file becomes your geometry table for the next SU step (e.g., `sushw` to write headers).

## Step 3 – CMP locations QC and binning

CMP (Common Midpoint) = midpoint between a source (sx, sy) and a receiver (gx, gy).

$$
CMP_{x} = \frac{sx + gx}{2}, ~ CMP_{y} = \frac{sy + gy}{2}
$$

In a straight 2D line, CMPs fall neatly along the line → CDP numbering is simple. But, in a crooked line survey (our dataset case), CMPs won’t always sit exactly on the line between sources & receivers. 

j
