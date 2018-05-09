function display_data(M,ATRTIME)
%display the first 3600 samples
TIME = 1:37000;
ATRTIME = double(ATRTIME);
figure(1); 
clf, box on, hold on
plot(TIME(1:37000), M(1:37000,1),'r');
% plot(TIME(1:3000), M(1:3000,2),'b');
xlim([1, 2000]);
ylim([-2, 2]);
for k = 1:360
    annot = ATRTIME(k)*128/1000;
    text(annot,0.5,num2str(k));
end;

xlabel('Time / s');
ylabel('Voltage / mV');
string=['ECG signal ',100];
title(string);

end