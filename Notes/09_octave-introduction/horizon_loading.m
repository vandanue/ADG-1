clear all; close all; clc;

% Read data
horizon = load('/media/vandanu/HDD/00_College/Asdos/ADG-1/Data/Caddo.txt');

x = horizon(:,1);
y = horizon(:,2);
z = horizon(:,5);

n_inline = (max(x) - min(x) + 1);
n_xline = (max(y) - min(y) + 1);

inline = [min(x):max(x)];
xline = [min(y):max(y)];

time = reshape(z, n_inline, n_xline);
time = time';

% Plot data
figure;
imagesc(inline, xline, time);
xlabel('Inline');
ylabel('Xline');
colorbar;
colormap(jet);

% Plot 3D horizon
figure;
surf(inline, xline, time);
axis('tight');
shading('interp');
set(gca, 'zdir', 'reverse', 'ydir', 'reverse');
xlabel('Inline');
ylabel('Xline');
zlabel('Time (ms)');
title('Caddo Horizon');
colorbar;
colormap(jet);
