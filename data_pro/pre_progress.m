function fdata = pre_progress(ordata)

%% this func just used for testing the filters

%origenal data
ordata = M(:,1)';
len = size(ordata,2);
time = 1 : len;
figure(1);
plot(time(1:3000),ordata(1:3000));
title('Origenal data');
xlabel('time');
ylabel('value');

%frequency anlysis
n = 3600;
m = fft(ordata,n);
fs = 360;
f = fs / n * (0 : n-1);
figure(2);
plot(f,m);
title('frequency');
xlabel('f/Hz');
ylabel('value/db');

%% utterworth filter 
fs = 360;
Wp = [50 130] * 2 /fs;
Ws = [40 140] * 2 /fs;
Rp = 3;
Rs = 45;
[N,wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,wn,'stop');
[H,W] = freqz(b,a,1024);
k = 0 : 1023;
figure(3);
plot((fs / 2) / 1024 * k,abs(H));
grid on
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(4);
% hold on
plot(time(1:10000),fdata(1:10000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%  
b = [1,1,1,1];
figure(5);
freqz(b,1);
fdata = filter(b,1,ordata);
mfd = abs(mf) / n;
figure(6);
% hold on
plot(time(1:1000),fdata(1:1000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%IIR 1
fs = 360;
Wp = [50 130] * 2 /fs;
Ws = [40 140] * 2 /fs;
Rp = 3;
Rs = 45;
[N,wn] = cheb1ord(Wp,Ws,Rp,Rs);
[b,a] = cheby1(N,Rp,wn,'stop');
[H,W] = freqz(b,a,1024);
k = 0 : 1023;
figure(7);
plot((fs / 2) / 1024 * k,abs(H));
grid on
%filter
fdata = filter(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(8);
% hold on
plot(time(1:1000),fdata(1:1000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%IRR 2
fs = 360;
Wp = [50 130] * 2 /fs;
Ws = [40 140] * 2 /fs;
Rp = 3;
Rs = 45;
[N,wn] = cheb2ord(Wp,Ws,Rp,Rs);
[b,a] = cheby2(N,Rs,wn,'stop');
[H,W] = freqz(b,a,1024);
k = 0 : 1023;
figure(9);
plot((fs / 2) / 1024 * k,abs(H));
grid on
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(10);
% hold on
plot(time(1:1000),fdata(1:1000),'g');
title('after filted data');
xlabel('time');
ylabel('value');
%% 椭圆 IRR
fs = 360;
Wp = [50 130] * 2 /fs;
Ws = [40 140] * 2 /fs;
Rp = 3;
Rs = 45;
[N,wn] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(N,Rp,Rs,wn,'stop');
[H,W] = freqz(b,a,1024);
k = 0 : 1023;
figure(11);
plot((fs / 2) / 1024 * k,abs(H));
grid on
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(13);
% hold on
plot(time(1:1000),fdata(1:1000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%FIR
wp1 = 0.28;
wp2 = 0.72;
ws1 = 0.33;
ws2 = 0.67;
% Wp = [wp1,wp2];
% Ws = [ws1,ws2];
Wp = [wp1,wp2] * pi;
Ws = [ws1,ws2] * pi;
wdel = min((ws1 - wp1),(wp2 - ws2));
N = ceil(8 * pi / wdel)-1;
Wn = (Wp + Ws) / 2;
window = blackman(N + 1);
b = fir1(N,Wn / pi,'stop',window);
figure(14);
freqz(b,1,1024);
title('FIR');
%filter
fdata = filtfilt(b,1,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(15);
% hold on
plot(time(1:1000),fdata(1:1000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
figure(16);
plot(f,20 * mfd);
%%基线漂移
fs = 360;
Wp =  1 * 2 / fs;
Ws = 0.1 * 2 / fs;
Rp = 3;
Rs = 45;
n = 3600;
[N,wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,wn,'high');
figure(17);
freqz(b,a,n,fs);
title('highpass');
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(18);
% hold on
plot(time(1:3000),fdata(1:3000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
figure(19);
plot(f,20 * mfd);
%%简单极点法
b = [0.9876,-0.9876];
a = [1,-0.9752];
figure(20);
freqz(b,a,3600,360);
%filter
fdata = filter(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(21);
% hold on
plot(time(1:10000),fdata(1:10000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%cheby 1 does not fill well
fs = 360;
Wp =  1 * 2 / fs;
Ws = 0.1 * 2 / fs;
Rp = 3;
Rs = 45;
n = 3600;
[N,wn] = cheb1ord(Wp,Ws,Rp,Rs);
[b,a] = cheby1(N,Rp,wn,'high');
figure(22);
freqz(b,a,n,fs);
title('highpass');
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(23);
% hold on
plot(time(1:3000),fdata(1:3000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%cheby 2 
fs = 360;
Wp =  1 * 2 / fs;
Ws = 0.1 * 2 / fs;
Rp = 3;
Rs = 45;
n = 3600;
[N,wn] = cheb2ord(Wp,Ws,Rp,Rs);
[b,a] = cheby2(N,Rs,wn,'high');
figure(22);
freqz(b,a,n,fs);
title('highpass');
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(23);
% hold on
plot(time(1:3000),fdata(1:3000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%tuo
fs = 360;
Wp =  1 * 2 / fs;
Ws = 0.1 * 2 / fs;
Rp = 3;
Rs = 45;
n = 3600;
[N,wn] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(N,Rp,Rs,wn,'high');
figure(24);
freqz(b,a,n,fs);
title('highpass');
%filter
fdata = filtfilt(b,a,ordata);
mf = fft(fdata,n);
mfd = abs(mf) / n;
figure(25);
% hold on
plot(time(1:3000),fdata(1:3000),'r');
title('after filted data');
xlabel('time');
ylabel('value');
%%%%%%%%%%%%%%%%%%
fs = 360;
nfft = 4096;
window = hamming(512);
overlap = 256;
f1 = fs / nfft * (0 : nfft - 1);
[pyy,f1] = pwelch(ordata,window,overlap,nfft,fs,'onesided');
figure(26);
plot(f1,1000 * pyy);
xlabel('Frequency(Hz)');
ylabel('Power spectral(db/Hz');
title('data welch');

end