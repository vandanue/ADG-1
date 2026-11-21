clear all; close all; clc;

addpath(genpath('/home/vandanu/programs/crewes/seismic'));

% Load data
seismic = load("../../Data/Stratton/seismic/Trace_well9.txt");
time = seismic(:,1);
trace = seismic(:,2);

##% Determine data size
##[m,n] = size(seismic);
##
##% Allocate space
##iamp = zeros(m,n);
##iph = zeros(m,n);
##ifreq = zeros(m,n);

% Run attributes: reflection strength, ins. phase, ins. freq.
iamp = ins_amp(trace);
iph = ins_phase(trace);
ifreq = ins_freq(trace, time);

##% Display original seismic and its attributes
##figure;imagesc(cdp,ts,data2);colorbar;xlabel('CDP');ylabel('Time (s)');title('Seismic input');colormap(seisclrs);
##figure;imagesc(cdp,ts,iamp);colorbar;xlabel('CDP');ylabel('Time (s)');title('Amplitude envelope');colormap(jet);
##figure;imagesc(cdp,ts,iph);colorbar;xlabel('CDP');ylabel('Time (s)');title('Instantaneous phase');colormap(jet);
##figure;imagesc(cdp,ts,ifreq,[0 70]);colorbar;xlabel('CDP');ylabel('Time (s)');title('Instantaneous freq');colormap(jet);
