close all; clear all; clc;

% Load nnet package
pkg load nnet

% Load data
seismic = load("../../Data/Stratton/seismic/Trace_well9.txt");
well = load("../../Data/Stratton/well/Well_9.txt");
load ../../Data/Stratton/seismic/tramp
load ../../Data/Stratton/seismic/trph
load ../../Data/Stratton/seismic/trf

% Transpose all data into row vector
pson = well(:,11)';
time = seismic(:,1)';
trace = seismic(:,2)';
tramp = iamp';
trph = iph';
trf = ifreq';

% Input data
% Set 4 attributes into one variable
%
% The input matrix P is structured as:
%
%       | trc(1)        trc(2)       ...     trc(N)   |
%       | tramp(1)      tramp(2)     ...     tramp(N) |
% P =   | trph(1)       trph(2)      ...     trph(N)  |
%       | trf(1)        trf(2)       ...     trf(N)   |
%
% Dimensions: P = 4 x N
% Each row represents a seismic attribute, while each column represents one data sample.
%
% Input attributes:
% - Seismic trace
% - Amplitude envelope
% - Instantaneous phase
% - Instantaneous frequency
P = zeros(4, length(pson));
P(1,:) = trace;
P(2,:) = tramp;
P(3,:) = trph;
P(4,:) = trf;

% Target output
%
% T = [pson(1)  pson(2)  ...  pson(N)]
%
% Dimensions: T = 1 x N
% Each column of P corresponds to one target value in T.
T = pson;

% Train the network using feed forward network with Levenberg-Marquardt optimization
% Using 65 neurons and tansig & purelin as transfer functions
% the untrained network, created with newff
net = newff([min(trace) max(trace)
             min(trph) max(trph)
             min(tramp) max(tramp)
             min(trf) max(trf)], ...
             [65 1], ...
             {'tansig','purelin'}, ...
             'trainlm');
net.trainParam.epochs = 500;
net.trainParam.goal = 1e-4;
% P as a normalized input and T as output
net = train(net, P, T);

% Simulate a before defined neural network
Tn = sim(net, P);

% Calculate the linear regression
p = polyfit(T, Tn, 1);
Tn_fit = polyval(p, T);
R = corrcoef(T, Tn);
r = R(1,2);
R2 = r^2;

% Display correlation plot
figure;
scatter(T, Tn);
hold on;
plot(T, Tn_fit, 'r-');
hold off;
xlabel('True sonic log');
ylabel('Predicted sonic log');
title(sprintf('True and predicted correlation: %.2f', R2));
axis tight;
axis ij;

% Sonic log and predicted sonic plot
figure;
plot(T, time, Tn, time, 'r');
axis tight;
axis ij;
xlabel('DT (\Delta t)')
ylabel('Time (ms)');
legend('True sonic log', 'Predicted sonic log');
