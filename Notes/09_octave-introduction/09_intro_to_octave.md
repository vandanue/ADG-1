# Introduction to MATLAB for Geophysics: Petrophysical Applications
MATLAB is common program for higher math and data manipulation. The basic data structure in MATLAB is the matrix (hence it stands for Matrix Laboratory). I assume that student already know what and array or matrix is and that you know the cells are addressed. For geoscience, MATLAB is a powerful computational tool for petrophysical analysis, enabling efficient processing of well log data and calculation of rock properties.

## Overview

## Basic MATLAB Syntax

### Matrix Operations
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

% Row-wise multiplication
result = [1 2 3] * [4; 5; 6];  % = 32
```

## Petrophysical Calculations

### Vshale Estimation
```matlab
GR_log = [50 80 120 90];  % API units
GR_min = 30;  % clean sand baseline
GR_max = 150; % shale baseline

vshale = (GR_log - GR_min) / (GR_max - GR_min);
```

### Porosity Calculation (Archie's Framework)
```matlab
depth_values = 1000:10:2000;  % meters
rho_bulk = 2.25;  % g/cc
rho_matrix = 2.71;  % g/cc (sandstone)

porosity = (rho_matrix - rho_bulk) / (rho_matrix - rho_fluid);
```

### Fluid Saturation
```matlab
% Sw from Archie equation components
Rt = 5;        % true resistivity
Ro = 1;        % formation resistivity index
a = 1; m = 2; n = 2;

Sw_n = (a * Ro) / (porosity^m * Rt);
Sw = Sw_n ^ (1/n);
```

## Plotting
You can visualize results using `plot()`, `loglog()`, or cross-plots independently.
