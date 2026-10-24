function cmap = seismic(n)
    % Petrel seismic colormap

    if nargin < 1
        n = 256;
    end

    % Control points relative position
    x0 = [ ...
        0.000;
        0.125;
        0.250;
        0.375;
        0.500;
        0.625;
        0.750;
        0.875;
        1.000
    ];

    % RGB control points (range 0-1)
    CT0 = [
        0.6314, 1.0000, 1.0000;
        0.4824, 0.5608, 0.8353;
        0.4078, 0.3608, 0.6196;
        0.4902, 0.4471, 0.5725;
        0.7765, 0.7765, 0.7765;
        0.7333, 0.6863, 0.6353;
        0.6471, 0.4902, 0.3490;
        0.8196, 0.5333, 0.0157;
        1.0000, 1.0000, 0.0000
    ];

    % RGB Interpolation
    x = linspace(0, 1, n);
    cmap = interp1(x0, CT0, x, 'linear');
end
