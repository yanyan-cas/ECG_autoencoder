function [fdata ] = data_filter( ordata,fs )
% design the filter to filt the origenal data
% elimnate the //
%fs = 360;
% butter high pass filter

Wp =  1 * 2 / fs;
Ws = 0.1 * 2 / fs;
Rp = 3;
Rs = 45;
[N,wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,wn,'high');
%filter
fdata = filtfilt(b,a,ordata);

% %low pass
% Wp = 65 /fs;
% Ws =  90 /fs;
% [N,wn] = buttord(Wp,Ws,Rp,Rs);
% [b,a] = butter(N,wn,'low');
% %filter
% fdata = filtfilt(b,a,fdata);

% if fs == 360
%     %%IRR Cheby2
%     Wp = [59 61] /fs;
%     Ws = [58 62] /fs;
% else
%     Wp = [49 51] /fs;
%     Ws = [48 52] /fs;
%     
% end
% [N,wn] = cheb2ord(Wp,Ws,Rp,Rs);
% [b,a] = cheby2(N,Rs,wn,'stop');
% %filter
% fdata = filtfilt(b,a,fdata);
end

