close all; clear all; clc;

% Load nnet package
pkg load nnet

% Load data
load ../../Data/matfiles/sonic % Sonic log
load ../../Data/matfiles/trace % Seismic trace
load ../../Data/matfiles/tramp % Amplitude envelope
load ../../Data/matfiles/trph % Instantaneous phase
load ../../Data/matfiles/trf % Instantaneous frequency

% Transpose all data into row vector
pson = pson';
tlog = tlog';
tramp = tramp';
trc = trc';
trf = trf';

% Input data
% Set 4 attributes into one variable
P = zeros(4, length(pson));
P(1,:) = trc/5; % Scale the seismic trace divided by 5
P(2,:) = tramp/5; % Scale the amplidute envelope attribute divided by 5
P(3,:) = trph;
P(4,:) = trf;

% Target output
T = pson;

% Train the network using feed forward network with Levenberg-Marquardt optimization
% Using 65 neurons and tansig & purelin as transfer functions
% the untrained network, created with newff
net = newff([min(trc) max(trc); min(trph) max(trph); min(tramp) max(tramp); min(trf) max(trf)], [65 1],{'tansig','purelin'},'trainlm');
net.trainParam.epochs = 500;
net.trainParam.goal = 1e-4;
% P as a normalized input and T as output
net = train(net, P, T);

% Simulate a before defined neural network
Tn = sim(net, P);

% Display plot
% Sonic log and seismic trace
figure;
plot(pson, tlog, trc, ts, 'r');
axis tight;
axis ij;
ylabel('Time (s)');
legend('Sonic log', 'Seismic');

% Sonic log and predicted sonic
figure;
plot(T, tlog, Tn, tlog, 'r');
axis tight;
axis ij;
xlabel('DT (\Delta t)')
ylabel('Time (s)');
legend('True sonic log', 'Predicted sonic log');
