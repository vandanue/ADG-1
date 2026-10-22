# Introduction to GNU Octave for Geophysics

MATLAB is a widely used numerical computing environment for mathematical operations, data analysis, and visualization. Its name comes from *Matrix Laboratory*, reflecting the importance of matrices and arrays in its computational framework.

For this course, we will use GNU Octave, a free and open-source numerical computing environment that is largely compatible with MATLAB syntax. Most basic MATLAB commands and scripts can also run in Octave with little or no modification. This allows us to focus on computational concepts and geophysical applications without requiring a MATLAB license.

In geophysics, numerical computing tools are useful for processing seismic data, analyzing well logs, calculating rock properties, and visualizing geophysical measurements. This introduction focuses on fundamental syntax and petrophysical calculations as an initial example of how numerical programming can support geophysical interpretation.

## GNU Octave: A Quick Preview

GNU Octave provides an interactive command window for executing commands, a script editor for writing and saving programs, and plotting functions for visualizing numerical results.

In the course materials, Octave will be used to introduce matrix operations, basic numerical calculations, and graphical visualization. The same concepts can also be applied to other geophysical tasks, including seismic data analysis and signal processing.

A typical workflow consists of:

1. Defining input data as vectors, matrices, or arrays.
2. Performing numerical calculations using built-in operators and functions.
3. Visualizing the results using plots.
4. Saving commands in a script (`.m` file) so that the analysis can be reproduced.

For example, the following commands create a simple dataset and display it as a plot:

```matlab
% Define sample data
depth = [0 100 200 300];
vshale = [0.1 0.2 0.3 0.4];

% Plot the data
plot(vshale, depth, 'o-');
xlabel('Volume of Shale');
ylabel('Depth (m)');
title('Example Well Log');
grid on;
```

Although the code block uses the `matlab` syntax label, the commands above can also be executed in GNU Octave.

## Basic MATLAB-Compatible Syntax

The examples below use MATLAB-compatible syntax and are intended to be executed in GNU Octave during practical sessions.

### Matrix Operations

Matrices and arrays are the fundamental data structures in MATLAB and Octave. Before proceeding, make sure you understand how to define vectors and matrices, access their elements, and distinguish between row and column vectors.

```matlab
% Row vector
vshale = [0.1 0.2 0.3 0.4];

% Column vector
depth = [0; 100; 200; 300];

% Matrix
logs = [vshale; porosity; permeability];

% Transpose
vshale_col = vshale';

% Element-wise operations
porosity_scaled = porosity .* 100;

% Matrix multiplication
result = [1 2 3] * [4; 5; 6];  % Result: 32
```

Note that `.*` performs element-wise multiplication, while `*` performs matrix multiplication. The dimensions of the matrices must be compatible with the operation being performed.

The matrix example involving `logs` assumes that `porosity` and `permeability` have already been defined as row vectors with the same number of elements as `vshale`.

## Petrophysical Calculations

The following examples illustrate how MATLAB-compatible syntax can be used for simple petrophysical calculations. The values are illustrative and should not be interpreted as measurements from a specific well.

### Vshale Estimation

Volume of shale (\(V_{\mathrm{sh}}\)) can be estimated from a gamma-ray log using a simple linear normalization:

```matlab
GR_log = [50 80 120 90];  % Gamma-ray log (API)
GR_min = 30;              % Clean-sand baseline
GR_max = 150;             % Shale baseline

vshale = (GR_log - GR_min) ./ (GR_max - GR_min);
```

This calculation normalizes the gamma-ray values between the clean-sand and shale baselines. The resulting values are approximate and may require additional corrections or interpretation depending on the formation and the assumptions used.

### Porosity Calculation

Porosity can be estimated from bulk density using the density-porosity relationship:

```matlab
rho_bulk = 2.25;   % Bulk density (g/cc)
rho_matrix = 2.71; % Matrix density (g/cc)
rho_fluid = 1.00;  % Fluid density (g/cc)

porosity = (rho_matrix - rho_bulk) / ...
           (rho_matrix - rho_fluid);
```

The equation assumes that the formation consists of a solid matrix and pore fluid, with their densities known. In practice, the appropriate matrix and fluid densities depend on the lithology and formation-fluid composition.

### Fluid Saturation

Archie's equation can be used to estimate water saturation from porosity and resistivity data. One common form is:

\[
S_w^n = \frac{aR_w}{\phi^m R_t}
\]

where \(S_w\) is water saturation, \(R_w\) is formation-water resistivity, \(R_t\) is true formation resistivity, \(\phi\) is porosity, and \(a\), \(m\), and \(n\) are empirical parameters.

```matlab
% Illustrative input values
Rt = 5;       % True formation resistivity
Rw = 1;       % Formation-water resistivity
a = 1;
m = 2;
n = 2;

Sw_n = (a * Rw) / (porosity^m * Rt);
Sw = Sw_n^(1/n);
```

This example assumes scalar porosity. If `porosity` is a vector, use element-wise operators such as `.^` and `./` where appropriate. The calculation also assumes that Archie's relationship is applicable to the formation being analyzed.

## Plotting and Visualization

Octave includes plotting functions that can be used to visualize numerical results. Common examples include `plot()` for ordinary plots, `loglog()` for logarithmic axes, and scatter plots for examining relationships between variables.

For example, the estimated shale volume can be plotted against depth:

```matlab
plot(vshale, depth, 'o-');
xlabel('Volume of Shale');
ylabel('Depth (m)');
set(gca, 'YDir', 'reverse');
grid on;
```

Reversing the vertical axis places increasing depth downward, which is a common convention for well-log displays.

## Key Takeaways

- GNU Octave is the primary application used for the practical examples in this material.
- MATLAB-compatible syntax allows many scripts to run in both environments.
- Vectors and matrices are essential for organizing and processing geophysical data.
- Numerical calculations become more useful when combined with visualization and reproducible scripts.
- The same programming fundamentals can be extended to more advanced geophysical applications.

## Another Example on Geophysical Applications

The matrix operations, numerical calculations, and plotting functions introduced in this section are not limited to simple mathematical examples. They also provide the computational foundation for more advanced geophysical applications. As the course progresses, these programming concepts can be used to analyze seismic data, investigate wave propagation, and relate geophysical measurements to subsurface properties.

The following examples provide a preview of how GNU Octave can support these applications.

### 1. Seismic Attributes: Extracting Information from Seismic Data

Seismic attributes are quantities calculated from seismic traces or seismic sections to highlight particular characteristics of the data. Examples include reflection amplitude, root-mean-square (RMS) amplitude, instantaneous frequency, and measures of trace similarity.

Octave can be used to perform these calculations through array operations and built-in mathematical functions. For example, RMS amplitude summarizes the overall amplitude level of a seismic trace:

```matlab
% Illustrative seismic trace
trace = [0.2 -0.3 0.7 -0.1 0.4];

% Calculate RMS amplitude
rms_amplitude = sqrt(mean(trace.^2));
```

This example illustrates how a few numerical operations can transform a sequence of seismic samples into a single descriptive value. When applied across many traces or time windows, similar calculations can help reveal spatial variations in seismic reflection characteristics.

### 2. Neural Networks: Learning Patterns from Data

Neural networks use numerical operations to learn relationships between input data and target outputs. In geophysics, these methods can be applied to tasks such as seismic facies classification, lithology prediction, and other data-driven interpretation problems.

Octave's matrix operations provide the basic computational tools needed to understand these methods. Model inputs, weights, and outputs can be represented as vectors and matrices, while mathematical functions are used to transform the data.

For example, a simplified neural-network calculation may apply weights to input features and pass the result through an activation function:

```matlab
% Illustrative input features and weights
x = [0.2; 0.5; 0.8];
w = [0.4 -0.3 0.6];
b = 0.1;

% Weighted sum followed by a sigmoid activation
z = w * x + b;
y = 1 / (1 + exp(-z));
```

This is only a single computational step, not a complete neural network. Training a model requires additional procedures, including defining a loss function and updating the model parameters. These concepts build on the vector and matrix operations introduced earlier.

### 3. Spectral Decomposition: Examining Frequency Content

A seismic trace contains information distributed across time and frequency. Spectral analysis helps examine how its energy varies with frequency, while seismic spectral decomposition investigates frequency-dependent responses across seismic data.

Octave provides functions such as `fft()` for calculating the discrete Fourier transform. The resulting spectrum can be used to inspect the frequency content of a signal.

```matlab
% Sampling parameters
fs = 1000;
t = 0:1/fs:1-1/fs;

% Construct an illustrative signal
trace = sin(2*pi*25*t) + 0.5*sin(2*pi*80*t);

% Calculate the amplitude spectrum
spectrum = abs(fft(trace));

% Frequency axis
n = length(trace);
frequency = (0:n-1) * fs/n;

% Plot the spectrum
plot(frequency, spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Amplitude Spectrum');
grid on;
```

The example contains two sinusoidal components, at 25 Hz and 80 Hz. The spectrum illustrates how a signal can be examined in the frequency domain rather than only in the time domain. Actual seismic spectral decomposition may involve additional processing, time windows, and interpretation of geological features.

### 4. Seismic Ray Tracing: Calculating Travel Times

Seismic ray tracing investigates the paths followed by seismic energy through a subsurface velocity model. It is useful for understanding source-receiver geometry, predicting travel times, and relating seismic observations to subsurface structure.

A basic travel-time calculation can be performed by dividing a ray path into segments and summing the travel time through each segment:

```matlab
% Illustrative ray-path segments
segment_length = [100 150 200];  % Segment lengths (m)
velocity = [2000 2500 3000];    % Velocity in each segment (m/s)

% Calculate total travel time
travel_time = sum(segment_length ./ velocity);
```

This calculation assumes that each segment has a known length and a constant velocity. It represents the travel time along a specified path, rather than determining the ray path itself. More advanced ray tracing requires additional calculations based on the velocity model and the governing ray equations.

### 5. Acoustic Finite-Difference Modeling: Simulating Wave Propagation

Finite-difference modeling approximates the derivatives in a wave equation using values defined on a discrete spatial grid. In acoustic wave simulation, this approach can be used to investigate how pressure waves propagate through a model with specified material properties.

In Octave, a numerical model can be represented using matrices, where each element corresponds to a grid point. The wavefield is updated over successive time steps using values from neighboring grid points.

The central programming concepts include:

- Creating arrays to represent the subsurface grid and wavefield.
- Applying mathematical operations to update the wavefield.
- Repeating calculations over multiple time steps.
- Visualizing the evolving wavefield.

Unlike a simple plotting exercise, a complete finite-difference simulation also requires a discretized wave equation, appropriate spatial and temporal sampling, source definition, boundary conditions, and numerical stability considerations. The matrix and array concepts introduced in this section provide the starting point for implementing such a simulation.

### 6. Velocity Analysis, Well-to-Seismic Tie, and Depth Conversion

Seismic interpretation often requires combining seismic travel times, velocity information, and well-log measurements. Octave can support these tasks through numerical calculations, interpolation, integration, and plotting.

Velocity analysis helps identify suitable velocities for correcting reflection moveout in seismic data. Well-to-seismic tie compares seismic reflections with a synthetic seismogram generated from well-log information, helping relate seismic events to geological boundaries observed at a well. Depth conversion then uses an appropriate velocity model to transform a time-domain interpretation into depth.

For a simple illustration, depth increments can be estimated from two-way travel-time intervals and interval velocities:

```matlab
% Illustrative interval velocities
dt = 0.004;                    % Two-way time interval (s)
v_interval = [1800 2000 2200]; % Interval velocity (m/s)

% Approximate depth increment per time sample
dz = v_interval .* dt / 2;

% Cumulative depth
depth = cumsum(dz);
```

The factor of two accounts for the two-way travel time. This example assumes that each velocity corresponds to the interval represented by one time sample. A practical depth-conversion workflow requires a velocity model consistent with the available seismic and well data, as well as appropriate treatment of the datum, time-depth relationship, and geological structure.

## Why These Applications Matter

The examples above demonstrate how the basic features of GNU Octave extend to different geophysical problems. Vector and matrix operations support data organization and numerical modeling, mathematical functions enable signal processing and parameter calculations, and plotting functions help communicate the results.

The objective at this stage is not to implement every method in full, but to become comfortable with the computational workflow. These fundamentals will make it easier to understand and implement the more specialized methods introduced in subsequent course materials.

## Repetition with `for` Loops

Loops allow a set of commands to be executed repeatedly without writing the same statements multiple times. A `for` loop is useful when the number of iterations is known in advance, such as processing several traces, iterating over multiple CMP gathers, or performing calculations across a range of values.

The general structure is:

```matlab
for i = start_value:end_value
    % Commands to repeat
end
```

For example, the following loop displays a message five times:

```matlab
for i = 1:5
    fprintf('This is iteration no. %d\n', i);
    pause(0.5);  % Optional: pause for 0.5 seconds
end
```

The variable `i` acts as the loop counter. The `fprintf()` function displays the current iteration number, while `pause(0.5)` introduces a short delay between iterations. The pause can be removed when it is not needed.

### Nested `for` Loops

A loop can also be placed inside another loop. This is called a *nested loop*. It is useful when calculations involve two dimensions, such as iterating over multiple traces and time samples.

```matlab
for i = 1:10
    for j = 1:5
        fprintf('i = %d, j = %d\n', i, j);
    end
end
```

In this example, the inner loop runs five times for each iteration of the outer loop. The complete program therefore executes the inner statement 50 times.

In geophysical applications, nested loops can be used to iterate over samples and traces, grid points, or combinations of model parameters. However, for large datasets, vectorized operations may be more efficient than explicitly looping over every element.

## Repetition with `while` Loops

A `while` loop repeats a set of commands as long as a specified logical condition is true. Unlike a `for` loop, which is often used when the number of iterations is predetermined, a `while` loop is useful when the stopping condition depends on a variable or calculation.

For example:

```matlab
x = 1;

while x < 100
    x = x + 1;
    fprintf('x = %d\n', x);
end
```

The loop increases `x` by one during each iteration and stops when `x` reaches 100. The condition is checked before every iteration, so the commands are no longer executed once `x < 100` becomes false.

A `while` loop requires particular care: the commands inside the loop must eventually change the condition or otherwise provide a way to stop. If the condition never becomes false, the program may run indefinitely.

This type of loop is useful for iterative calculations, such as refining an estimated parameter until the change between successive iterations becomes sufficiently small.

## Geophysical Toolboxes and Libraries

GNU Octave provides the basic numerical computing environment, but specialized toolboxes can extend its capabilities for seismic processing, well-log analysis, and geophysical data handling. The following tools are examples worth exploring.

| Toolbox or resource | Purpose |
|---|---|
| [CREWES MATLAB Toolbox](https://www.crewes.org/ResearchLinks/FreeSoftware/) | A collection of seismic processing, modeling, and visualization routines. This toolbox will be used as a practical resource in the course. |
| SeismicLab | An additional toolbox to explore for seismic processing and analysis. Check the specific project's documentation and supported software versions before installation. |
| [SegyMAT](https://segymat.sourceforge.net/) | A collection of MATLAB-compatible functions for reading and writing SEG-Y files. It explicitly supports both MATLAB and GNU Octave. |
| SeisLab | A collection of MATLAB functions for seismic and well-log analysis. Compatibility with the current Octave release should be checked before use. |
| [Awesome Open Geoscience](https://github.com/softwareunderground/awesome-open-geoscience) | A broader, community-curated list of open-source geoscience software, datasets, tutorials, and other resources. It covers more than MATLAB- or Octave-based tools. |

Not every MATLAB toolbox works identically in GNU Octave. Before using a toolbox, check its documentation, dependencies, licensing, and compatibility with your installed software version.

## Installing the CREWES Toolbox in GNU Octave

The CREWES educational toolbox is available from the [CREWES Free Software page](https://www.crewes.org/ResearchLinks/FreeSoftware/). The download page provides the archive `crewes_educational.zip`, along with documentation and related seismic-processing learning materials.

The official installation instructions are written for MATLAB. The following steps show how to add the extracted toolbox to GNU Octave's search path. Adding the directories makes the functions discoverable, but does not guarantee that every MATLAB-specific function will work in Octave.

### Step 1: Download and Extract the Toolbox

1. Open the CREWES Free Software webpage.
2. Download the archive named `crewes_educational.zip`.
3. Extract the ZIP file into a permanent folder. For example, on Windows, you could use:

   `C:/Annora/data/crewes_educational`

   Replace this example with the actual location on your computer. Avoid moving the folder after configuring the search path.

### Step 2: Add the Folder and Its Subdirectories to the Path

Octave needs to know where to look for external functions. Because CREWES contains functions organized into multiple subdirectories, adding only the top-level folder may not be sufficient.

#### Option A: Using the Octave GUI

1. Open GNU Octave and locate the File Browser panel.
2. Navigate to the directory containing the extracted `crewes_educational` folder.
3. Select the `crewes_educational` folder.
4. Right-click the folder and look for `Add to Path`, then select `Selected Directories and Subdirectories`. The exact menu wording may vary between Octave versions.
5. Return to the Command Window and run:

   ```matlab
   savepath
   ```

This saves the configured search path so that Octave can restore it in subsequent sessions. The command normally returns `0` if saving succeeds.

#### Option B: Using Commands

The same operation can be performed directly in the Command Window:

```matlab
% Set this to the folder where CREWES was extracted
root = 'C:/Annora/data/crewes_educational';

% Add the folder and its subdirectories to the search path
addpath(genpath(root));

% Save the path for future Octave sessions
savepath;
```

The function `genpath()` generates a path containing the specified directory and its subdirectories, while `addpath()` adds those directories to Octave's search path.

Use forward slashes in Windows paths as shown above, and make sure that `root` matches the actual folder on your computer.

### Step 3: Verify the Installation

Before running a toolbox function, check whether Octave can locate it:

```matlab
which plotseis
```

If the function is found, Octave should display its file location. Next, run:

```matlab
plotseis
```

In the CREWES toolbox, `plotseis` is a function for displaying seismic sections and may show a demonstration when called without input arguments. If the installation is working and the required functionality is compatible with your Octave version, a plot window should appear.

If `which plotseis` returns no function location, revisit Step 2 and confirm that the correct folder and its subdirectories have been added. If the function is found but produces an error when executed, the issue may instead involve toolbox compatibility, dependencies, or graphics functionality.

For actual seismic data, `plotseis` can also be called with a seismic matrix and, when needed, its time and spatial axes. This makes it useful for visualizing seismic sections during processing and interpretation.