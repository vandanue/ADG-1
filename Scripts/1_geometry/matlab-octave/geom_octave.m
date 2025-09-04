%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc
load SPS_extract.txt
load RPS_extract.txt

% Ingat no of shots: 251,no of receiver in each shot: 282,total number of traces is 251*282=70782, jumlah trace tersebut setelah kill trace -1 - 0

%%%menyusun matrix sps untuk seluruh trace (70782)%%%%%%
for i=1:251
sps_for_traces_in_each_shot{i}=repmat(SPS_extract(i,:),282,1);
end
sps_all_traces=cell2mat(sps_for_traces_in_each_shot');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%menyusun matrix rps untuk seluruh trace (70782)%%%%%%
for i=1:251
rps_for_traces_in_each_shot{i}=RPS_extract([(i*2)-1:281+(i*2)-1]',:);
end
rps_all_traces=cell2mat(rps_for_traces_in_each_shot');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% menghitung offset
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%menghitung cdp untuk masing-masing trace
%%%dikarenakan interval geophone 25m dan interval sumber 50m, maka:
%%%cdp untuk shot pertama adalah 1 s/d 282
%%%cdp untuk shot kedua adalah 5 s/d 286
%%%cdp untuk shot ketiga adalah 9 s/d 290 dst....(lihat ilustrasi stacking diagram dibawah untuk memahaminya)
for i=1:251
cdp_each_shot{i}=[(4*i-3):281+(4*i-3)]';
end
cdp_all_traces=cell2mat(cdp_each_shot');

geom_header=[sx,sy,selev,sstat,gx,gy,gelev,gstat,cdp_all_traces,offset];

save -ascii geom_header.txt geom_header


%%%%plot koordinat sumber dan penerima
plot(sx,sy,'r*'); hold on
plot(gx,gy,'b^');xlabel('Easting');ylabel('Northing');legend('Source','Geophone');title("Source Receiver Plot")
%%%%akhir dari kode
