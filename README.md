 <img src="./img/img_1.png"/>

# Geophysical Data Analysis 1

Course notes for Geophysical Data Analysis 1, taught by Dr. Ayunda Aulia Valencia, S.T., M.T. and Agus Riyanto, M.Si., at the Department of Geosciences, Faculty of Mathematics and Natural Sciences, Universitas Indonesia, for the [Bachelor's Program in Geophysics](https://geosciences.ui.ac.id/program-studi-s1-geofisika/).

The course covers seismic data processing and analysis using Seismic Unix (SU), GNU Octave, and other computational tools. The repository contains lecture notes, practical exercises, scripts, and supporting figures organized by lecture week.

## Seismic Processing Workflow

The following diagram illustrates a conventional seismic reflection processing workflow, from raw seismic data to migrated output. The actual processing sequence may vary depending on the dataset and processing objectives.

```mermaid
flowchart TD
    A[Reformat] --> B[Geometry and Trace Edits]
    B --> C[F-K Filter]
    C --> D[Bandpass Filter]
    D --> E[Elevation Statics Correction]
    E --> F[1st Pass Velocity Analysis]

    %% Velocity analysis and statics
    F --> F1[1st Pass Residual Statics]
    F1 --> F2[2nd Pass Velocity Analysis]
    F2 --> F3[2nd Pass Residual Statics]

    E --> G[Deconvolution]
    G --> H[Residual Statics]
    F3 --> H
    H --> I[Amplitude Recovery]
    F2 -.-> I
    I --> J[CDP Denoise]

    subgraph BRANCHES[" "]
        direction LR

        subgraph REL["Relative Amplitude"]
            direction TD
            R1[AGC] --> R1a[3rd Pass Velocity Analysis]
            R1 --> R2[NMO Re-apply: VEL-3]
            R1a --> R2
            R2 --> R3[Stack] --> R4[Time Migration] --> R5[SEG-Y Out VOL1]
        end

        subgraph TRUE["True Amplitude"]
            direction TD
            T1[NMO Re-apply: VEL-3]
            T2[Stack]
            T4[Time Migration]
            T5[SEG-Y Out VOL2]

            T1 --> T2 --> T4 --> T5
        end
    end

    J --> R1
    J --> T1
    R1a -.-> T1

    style BRANCHES fill:none,stroke:none
    style REL fill:#E8F1FC,stroke:#3973AC,stroke-width:2px,color:#17365D
    style TRUE fill:#E8F5E9,stroke:#438653,stroke-width:2px,color:#20552A

```

## Material

The repository is organized by lecture week. Each numbered directory contains the notes and related materials available for that topic.

| Directory | Topic |
|---|---|
| `01_linux-and-setup/` | Introduction to Linux, WSL installation, and Seismic Unix setup |
| `02_geometry/` | Seismic geometry assignment and application using Octave and Python |
| `03_gain/` | Seismic amplitude recovery and gain testing |
| `04_noise-attenuation/` | Seismic noise attenuation |
| `05_deconvolution-and-statics-correction/` | Seismic deconvolution and statics correction, both elevation and residual statics |
| `06_velocity-analysis-and-stacking/` | Velocity analysis, normal moveout (NMO), and stacking |
| `07_stolt-migration/` | Stolt migration |
| `09_octave-introduction/` | Introduction to GNU Octave and MATLAB-compatible computing |
| `10_seismic-attributes/` | Seismic attributes |
| `11_neural-network-in-seismic/` | Neural networks in seismic applications |
| `12_spectral-decomposition/` | Seismic spectral decomposition |
| `13_seismic-ray-tracing/` | Seismic ray tracing |
| `14_acoustic-finite-difference/` | Acoustic wave simulation using the finite-difference method |
| `15_velocity-well-tie-and-depth-conversion/` | Velocity analysis, well-to-seismic tie, and depth conversion |

Weeks 8 and 16 are reserved for the midterm and final examinations, respectively. Some materials may be incomplete or subject to revision as the course notes are updated.

## Tools and Technologies

- **Seismic Unix (SU):** Seismic data processing and shell-based workflows.
- **GNU Octave:** Numerical computing, signal processing, and seismic analysis. MATLAB-compatible scripts may also be used where applicable.
- **Python:** Supporting scripts and computational exercises.
- **Linux/Unix:** Command-line tools and scripting for seismic processing.

Refer to the individual lecture notes for topic-specific instructions, scripts, and requirements.

## Contributing

Corrections, improvements, and additional examples are welcome.

1. Fork the repository.
2. Create a branch for your changes.
3. Commit your changes with descriptive commit messages.
4. Push your branch and submit a pull request.

## License

No license has currently been specified for this repository. Unless otherwise stated, all rights are reserved by the repository owner.

## Acknowledgments

- Dr. Ayunda Aulia Valencia, S.T., M.T., and Agus Riyanto, M.Si., for teaching Geophysical Data Analysis 1 (SCGF603501).
- The Center for Wave Phenomena (CWP) at the Colorado School of Mines for developing Seismic Unix.

