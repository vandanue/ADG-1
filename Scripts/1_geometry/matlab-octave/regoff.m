clear; clc
%%%offset regularization...
right=[25:25:3525]';
left=[-3525:25:-25]';
offset_each_shot=[left;right];
offset_all_shot=repmat(offset_each_shot,251,1);

%%%mengganti offset pada geom_header.txt dengan offset yang baru
load geom_header.txt
geom_header_reg_offset=[geom_header(:,[1:9]),offset_all_shot];
save -ascii geom_header_reg_offset.txt geom_header_reg_offset
%%%%%
