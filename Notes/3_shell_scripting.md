# Shell Scripting and Its Application in Seismic Unix

## What is Shell Scripting?

Shell scripting is basically the art of telling your computer what to do automatically. Instead of typing each command one by one, you write them as a script that runs in a Unix shell (like bash, sh, or csh). The script can handle file operations, execute programs, or even manage whole workflows. In short, it’s a smart way to automate repetitive or multi-step tasks, reducing manual work and minimizing human error.

## Application in Seismic Unix

Seismic Unix (SU) is a collection of seismic data processing tools commonly used in geophysics. Shell scripting is widely used with SU to:

- **Automate Data Processing:** Run multiple SU commands in sequence to process seismic data without manual intervention.
- **Batch Processing:** Handle large datasets by looping over files and applying SU tools.
- **Workflow Management:** Organize complex processing workflows, including data conversion, filtering, stacking, and visualization.
- **Reproducibility:** Ensure consistent results by saving and sharing scripts with processing steps.

In essence, shell scripting turns complex SU workflows into repeatable, sharable, and efficient processes.

## Example: Seismic Unix Workflow in Bash

Below is a simple Bash script that demonstrates a typical SU workflow using `suwind`, `sufilter`, and `suximage`:

```bash
#!/bin/sh

# Example workflow: applying bandpass filter using SU tools

# Select one shot (using ep keyword)
suwind < Line_001_geom.su key=ep min=32 max=32 > Line_001_geom_ep32.su

# Plot one shot before bandpass filter
suximage < Line_001_geom_ep32.su perc=80 title="Shot 32 before BPF" &

# Do BPF in one shot
sufilter < Line_001_geom_ep32.su f=15,20,50,60 amps=0,1,1,0 > Line_001_geom_ep32_bp.su

# Plot shot after BPF
suximage < Line_001_geom_ep32_bp.su perc=80 title="Shot 32 after BPF" &

# Apply filter to all data
sufilter < Line_001_geom.su f=15,20,50,60 amps=0,1,1,0 > Line_001_geom_bp.su
```
This short script automatically selects a shot, applies a bandpass filter, and visualizes the results — all in one go. Instead of manually typing each command, you can just run this once and focus on analyzing the output.

## What If We Don’t Use Shell Scripting?
Without shell scripting, you’d have to type every SU command line by line — for every dataset, every parameter change, and every visualization. For example, applying the same filter to multiple shots would mean copying and pasting commands repeatedly.

That’s not only time-consuming but also prone to mistakes (like overwriting files or mismatching parameters). Shell scripting, on the other hand, allows you to:

- Run your entire workflow with a single command.
- Modify just one parameter (like `ep` or filename) and apply it to all processes.
- Reproduce workflows quickly for different datasets or experiments.

Basically, it’s the difference between manual labor and smart automation.

## Optimizing Shell Scripting
You can make your shell scripts even more flexible by using variables (`$`) for input parameters instead of hardcoding filenames. This lets you change inputs easily without editing every line.

For example, instead of this:
```bash
# Plot before and after bandpass filter
suximage < Line_001_geom_ep32.su
suximage < Line_001_geom_ep32_bp.su
```

You can write:
```bash
#!/bin/sh

# Parameters
indata=Line_001_geom.su   # Input seismic data
ep=32                     # Shot number (EP)
f=0,15,50,60              # Filter frequencies (Hz)
amps=0,1,1,0              # Filter amplitudes
perc=80                   # Display percentile for suximage

# Select one shot
suwind < $indata key=ep min=$ep max=$ep > ${indata%.su}_ep${ep}.su

# Plot shot before bandpass filter
suximage < ${indata%.su}_ep${ep}.su perc=$perc title="Shot $ep before BPF" &

# Apply bandpass filter
sufilter < ${indata%.su}_ep${ep}.su f=$f amps=$amps > ${indata%.su}_ep${ep}_bp.su

# Plot shot after bandpass filter
suximage < ${indata%.su}_ep${ep}_bp.su perc=$perc title="Shot $ep after BPF" &

# Apply the same filter to the full dataset
sufilter < $indata f=$f amps=$amps > ${indata%.su}_bp.su
```
Now you only need to edit the parameter section at the top — for example, if you want to change the input file, shot number, or filter frequencies, you just tweak those values and rerun the script.

This parameterized setup makes your SU workflow:
- More modular — easily reusable for any dataset.
- Less error-prone — no repeated editing of filenames or parameters.
- Cleaner — everything important is declared upfront.

In short, this is the smarter, more scalable way to write shell scripts for seismic processing.