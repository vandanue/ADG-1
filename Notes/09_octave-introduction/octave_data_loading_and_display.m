close all; clear all; clc;
warning('off', 'all');

addpath('/home/vandanu/programs/crewes/segy');

data_path = '/media/vandanu/HDD/00_College/Research/Volve/Seismic/3D/ST0202R08_PS_PSDM_FULL_OFFSET_PP_TIME.MIG_FIN.POST_STACK.3D.JS-017534.segy';

disp('Membaca data SEGY dan Trace Headers...');
[data, samplerate, th] = altreadsegy(data_path, 'textformat', 'ascii', 'traceheaders', 'yes');

t = size(data, 1);
num_traces = size(data, 2);

ilines = th(98, :); % Inline
xlines = th(96, :); % Crossline

% Rentang asli berdasarkan isi header file SEG-Y
min_il = 1932; max_il = 2536;
min_xl = 9985; max_xl = 10369;

n_il = max_il - min_il + 1;
n_xl = max_xl - min_xl + 1;

disp('Menyusun volume 3D penuh...');
data3D = NaN(n_xl, n_il, t);

for i = 1:num_traces
    idx_il = ilines(i) - min_il + 1;
    idx_xl = xlines(i) - min_xl + 1;
    data3D(idx_xl, idx_il, :) = data(:, i);
end

% --- OPTIMASI MEMORI ---
disp('Membersihkan RAM...');
clear data th ilines xlines;

% --- PROSES CROPPING ---
disp('Melakukan cropping volume...');
crop_il_min = 2150; crop_il_max = 2250;
crop_xl_min = 10150; crop_xl_max = 10200;

idx_il_start = crop_il_min - min_il + 1;
idx_il_end   = crop_il_max - min_il + 1;
idx_xl_start = crop_xl_min - min_xl + 1;
idx_xl_end   = crop_xl_max - min_xl + 1;

data3D_crop = data3D(idx_xl_start:idx_xl_end, idx_il_start:idx_il_end, :);

% Hapus matriks 1 GB untuk membebaskan RAM
clear data3D;

% --- PLOTTING MODE RINGAN ---
disp('Menyiapkan plot dengan mode ringan (Downsampling & Flat Shading)...');

% Bikin vektor waktu DULU sebelum di-downsample
time = [0.8 : samplerate : 0.8+(t-1)*samplerate]';

% Mengurangi resolusi waktu (ambil setiap sampel ke-4)
step_t = 4;
time_plot = time(1:step_t:end);
data3D_plot = data3D_crop(:, :, 1:step_t:end);

% Buat grid menggunakan waktu yang sudah dikurangi resolusinya
[x, y, z] = meshgrid(crop_il_min:crop_il_max, crop_xl_min:crop_xl_max, time_plot);

% Posisi slice (di tengah-tengah volume hasil crop)
slice_x = round((crop_il_min + crop_il_max) / 2);
slice_y = round((crop_xl_min + crop_xl_max) / 2);
slice_z = time_plot(round(length(time_plot) / 2));

figure('Name', '3D Seismic Volve (Lightweight)', 'Position', [100 100 900 700]);
slice(x, y, z, data3D_plot, slice_x, slice_y, slice_z);

% Visualisasi dengan flat shading agar rotasi tidak lag
set(gca, 'zdir', 'reverse');
axis('tight');
shading('flat');
title(['3D Seismic (IL ', num2str(crop_il_min), '-', num2str(crop_il_max), ', XL ', num2str(crop_xl_min), '-', num2str(crop_xl_max), ')']);
xlabel('Inline');
ylabel('Crossline');
zlabel('Time (s)');
colormap(jet);
colorbar;
view(-37.5, 30);
disp('Selesai!');
