close all; clear all; clc
% ----------------------- Offset Regularization ----------------------
right=[25:25:3525]';
left=[-3525:25:-25]';
offset_each_shot=[left;right];
offset_all_shot=repmat(offset_each_shot,251,1);

% ----------------------- Modify the Offset ----------------------
load geom_header.txt
geom_header_reg_offset=[geom_header(:,[1:9]),offset_all_shot];
save -ascii geom_header_reg_offset.txt geom_header_reg_offset

% % ----------------------- Show the Plot ----------------------
offset = geom_header(:,10); 
cdp = geom_header(:,9);

sx = geom_header_reg_offset(:,1);
sy = geom_header_reg_offset(:,2);
gx = geom_header_reg_offset(:,5);
gy = geom_header_reg_offset(:,6);
offset_reg = geom_header_reg_offset(:,10); 
cdp_reg = geom_header_reg_offset(:,9);

cmp_x = (geom_header_reg_offset(:,1)+geom_header_reg_offset(:,5))/2;
cmp_y = (geom_header_reg_offset(:,2)+geom_header_reg_offset(:,6))/2;

figure;plot(cdp,offset);title('Stacking Diagram Before Regularization');xlabel('CDP');ylabel('Offset')
figure;plot(cdp_reg,offset_reg);title('Stacking Diagram After Regularization');xlabel('CDP');ylabel('Offset')

figure;
plot(sx,sy,'r*'); hold on
plot(gx,gy,'b^');
plot(cmp_x,cmp_y,'g+');
xlabel('Easting');
ylabel('Northing');
legend('Source','Geophone','CMP Location','Location','NorthWest');
title('Source-Receiver Plot and CMP Locations');
grid on
