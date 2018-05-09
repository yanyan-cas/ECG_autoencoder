function display_feature(data)
%display the first frature

figure(2); 
clf, box on, hold on
TIME = 1 : 340;
plot(TIME, data(1:340,1),'r');
xlabel('Time');
ylabel('Voltage / mV');
string=['ECG signal ',100];
title(string);
end