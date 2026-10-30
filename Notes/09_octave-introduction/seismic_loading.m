clear all; close all; clc;

addpath('/home/vandanu/programs/crewes/segy');

% data loading
[data, samplerate, header] = altreadsegy('/media/vandanu/HDD/00_College/Asdos/ADG-1/Data/3Dseismic.sgy', 'textformat', 'ascii', 'traceheaders', 'yes');
inline = 119;
xline = 81;
t = size(data, 1);
time = [0.8:samplerate:0.8 + (t-1)*samplerate];

% transpose data
data = data';
data = reshape(data, [xline, inline, t]);

% Plot data
[x, y, z] = meshgrid(1:inline, 1:xline,time);

figure;
slice(x, y, z, data, 100, 50, 1);
set(gca, 'zdir', 'reverse');
axis('tight');
shading('interp');
colormap(viridis);
title('3D seismic');
xlabel('Inline');
ylabel('Xline');
zlabel('Time (s)');
