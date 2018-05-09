function wave = adaptWind(time,pre_time,pos_time,norm_data)
wave  = zeros(340,1);
preselect = floor(pre_time / 2);
posselect = floor(pos_time * 2 / 3);
if preselect >139
    preselect = 139;
end
if posselect > 200
    posselect = 200;
end
wave(140 -preselect : 140 + posselect,1) = norm_data(time - preselect : time + posselect,1);
wave(1:140-preselect,1) = wave(140-preselect,1);
wave(140 + posselect:340,1) = wave(140 + posselect,1);
% wave(1:140-preselect,1) = 0.5; 
% wave(140 + posselect:340,1) = 0.5;
end