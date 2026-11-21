clear all; close all; clc;

addpath('/home/vandanu/programs/crewes/segy');

% Load data
seismic = "../../Data/Stratton/seismic/Stratton3D_crop_XL89.sgy";

% Read SEG-Y
[data, samplerate, header] = altreadsegy(seismic, 'textformat', 'ascii', 'traceheaders', 'yes');

% Determine data size
[ns, ncdp] = size(data);

% Time and CDP axes
time = (0:ns-1) * samplerate;
cdp = 1:ncdp;

% Calculate attributes
iamp = ins_amp(data);
iph = ins_phase(data);
ifreq = ins_freq(data, samplerate);

% Display original seismic
figure;
imagesc(cdp, time, data);
set(gca, 'YDir', 'reverse');
colorbar;
xlabel('CDP');
ylabel('Time (s)');
title('Seismic Input - XL 89');
colormap(gray);

% Amplitude envelope
figure;
imagesc(cdp, time, iamp);
set(gca, 'YDir', 'reverse');
colorbar;
xlabel('CDP');
ylabel('Time (s)');
title('Amplitude Envelope - XL 89');
colormap(jet);

% Instantaneous phase
figure;
imagesc(cdp, time, iph);
set(gca, 'YDir', 'reverse');
colorbar;
xlabel('CDP');
ylabel('Time (s)');
title('Instantaneous Phase - XL 89');
colormap(jet);

% Instantaneous frequency
figure;
imagesc(cdp, time, ifreq, [0 70]);
set(gca, 'YDir', 'reverse');
colorbar;
xlabel('CDP');
ylabel('Time (s)');
title('Instantaneous Frequency - XL 89');
colormap(jet);
