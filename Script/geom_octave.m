%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;

load SPS_extract.txt
load RPS_extract.txt

% From the data header, no of shot: 251, no of receiver in each shot: 282, total number of traces is 251*282=70782. Total trace is only from seismic data without aux.
% Input Parameter
no_of_shot = 251;
no_of_receiver = 282;

% ----------------------- Expanding SPS for all traces ----------------------
for i=1:no_of_shot
sps_for_traces_in_each_shot{i}=repmat(SPS_extract(i,:),no_of_receiver,1);
end
sps_all_traces=cell2mat(sps_for_traces_in_each_shot');

% ----------------------- Expanding RPS for all traces ----------------------
for i=1:no_of_shot
rps_for_traces_in_each_shot{i}=RPS_extract([(i*2)-1:(no_of_receiver-1)+(i*2)-1]',:);
end
rps_all_traces=cell2mat(rps_for_traces_in_each_shot');

% ----------------------- Calculating offset ----------------------
sx=sps_all_traces(:,2);
sy=sps_all_traces(:,3);
selev=sps_all_traces(:,4);
sstat=sps_all_traces(:,5);

gx=rps_all_traces(:,2);
gy=rps_all_traces(:,3);
gelev=rps_all_traces(:,4);
gstat=rps_all_traces(:,5);
ox=gx-sx;
oy=gy-sy;
offset=sqrt(ox.^2+oy.^2);

% ----------------------- Assigning CDP Number ----------------------
for i=1:no_of_shot
cdp_each_shot{i}=[(4*i-3):281+(4*i-3)]';
end
cdp_all_traces=cell2mat(cdp_each_shot');

% ----------------------- Saving header matrix ----------------------
geom_header=[sx,sy,selev,sstat,gx,gy,gelev,gstat,cdp_all_traces,offset];
save -ascii geom_header.txt geom_header

% ----------------------- Plot of source-receiver ----------------------
plot(sx,sy,'r*'); hold on
plot(gx,gy,'b^');xlabel('Easting');ylabel('Northing');legend('Source','Geophone');title('Source Receiver Plot'); grid on