function cmap = seismic(n)
    if nargin < 1
        n = 256; % Jumlah tingkatan warna default
    end

    % Titik batas warna (Blue - White - Red)
    x0 = [0; 0.5; 1];
    % Matriks warna RGB triplet [0, 1]
    CT0 = [
        0.0, 0.0, 0.3;  % Biru Tua
        1.0, 1.0, 1.0;  % Putih
        0.5, 0.0, 0.0   % Merah Tua
    ];

    % Melakukan interpolasi untuk menghasilkan matriks n x 3
    cmap = interp1(x0, CT0, linspace(0, 1, n));
end

