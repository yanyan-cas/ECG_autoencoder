function [sdata] = Hsplit(M,ATRTIME,frequency)
%  HSPLIT Summary of this function goes here
%  To get more information ,We aloud part of overlap and 
%  define a window with length of 340 data points(the R peak of the wave is
%  located at 141th point)
%  The R marks are getting from boying company's software.
n = size(M);
sdata = [];
if n ==0
   return; 
end
data = data_filter(M(:,1),frequency); % butter high pass filter
data = resample(data,360,128);        % resample the data form 128 to 360
frequency = 360;
norm_data = normalize(data);          % normalize the data to [0,1]
Rtime = round(frequency * ATRTIME(2:size(ATRTIME,1)-1,1)/1000);
wave = [];
for l = 2 : size(Rtime,1)-1           % split data to windows
    tmp = zeros(340,1);
    pos_time = Rtime(l+1) - Rtime(l);
    pre_time = Rtime(l) - Rtime(l - 1);
    if  (pos_time < 300 || pre_time < 280) && (pos_time >50 && pre_time > 50)            
        tmp = adaptWind(Rtime(l),pre_time,pos_time,norm_data);
    else
        tmp = norm_data(Rtime(l)-140 : Rtime(l)+199,1);
    end
    wave = [wave,tmp];       
end
sdata = wave;
end

