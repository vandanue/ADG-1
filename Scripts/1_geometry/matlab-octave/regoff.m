close all; clear all; clc
% ----------------------- Offset Regularization ----------------------
% Use split spread configuration
% NTO: 25 m
% Geophone interval: 25 m
right = [25:25:3525]';                      
left = [-3525:25:-25]';                     
offset_each_shot = [left;right];
offset_all_shot = repmat(offset_each_shot,251,1);

% ----------------------- Modify the Offset ----------------------
load geom_header.txt
geom_header_reg_offset=[geom_header(:,[1:9]),offset_all_shot];
save -ascii geom_header_reg_offset.txt geom_header_reg_offset

% ----------------------- Show the Plot ----------------------
% Source Receiver Location


offset = geom_header(:,10); 
cdp = geom_header(:,9);

offset_reg = geom_header_reg_offset(:,10); 
cdp_reg = geom_header_reg_offset(:,9);

total_cdp = cdp(length(cdp),1);

% Stacking Diagram
% Before Regularization
figure;
scatter(cdp,offset,'b.');
title(sprintf('Stacking Diagram Before Regularization (# CDP: %d)', total_cdp));
xlabel('CDP (x_m)');
ylabel('Offset (x_o)');
% After Regularization
figure;
scatter(cdp_reg,offset_reg,'b.');
title(sprintf('Stacking Diagram After Regularization (# CDP: %d)', total_cdp));
xlabel('CDP (x_m)');
ylabel('Offset (x_o)');

sx = geom_header_reg_offset(:,1);
sy = geom_header_reg_offset(:,2);
gx = geom_header_reg_offset(:,5);
gy = geom_header_reg_offset(:,6);
cmp_x = (geom_header_reg_offset(:,1)+geom_header_reg_offset(:,5))/2;
cmp_y = (geom_header_reg_offset(:,2)+geom_header_reg_offset(:,6))/2;

% Source-receiver Plot
figure;
plot(sx,sy,'r*'); hold on
plot(gx,gy,'b^');
plot(cmp_x,cmp_y,'g+');
xlabel('Easting');
ylabel('Northing');
legend('Source','Geophone','CMP Location','Location','Best');
title('Source-Receiver Plot and CMP Locations');
grid on

% %% (1) Geometry map in UTM
% figure;
% subplot(1,2,1); hold on; grid on; axis equal
% plot(sx, sy, 'ro', 'MarkerFaceColor','r', 'DisplayName','Shot');
% plot(gx, gy, 'bv', 'MarkerFaceColor','b', 'DisplayName','Receiver');
% xlabel('UTM Easting (m)');
% ylabel('UTM Northing (m)');
% title('Acquisition Geometry (UTM)');
% legend show;
% 
% %% (2) Stacking diagram (CDP domain)
% subplot(1,2,2); hold on; grid on
% plot(cdp_reg, sx, 'r.', 'DisplayName','Shot CDP');
% plot(cdp_reg, gx, 'b.', 'DisplayName','Receiver CDP');
% xlabel('CDP number');
% ylabel('UTM Easting (m)'); % or offset, depending on your case
% title('Stacking Diagram');
% legend show;