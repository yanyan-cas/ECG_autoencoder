function display_feature( data )
%DISPLAY Summary of this function goes here
figure(1); 
clf, box on
TIME = 1 : 340;
avg = 500 * mean(data,2);
avg = floor(abs(avg) - abs(max(avg)));
index = find(avg == 0);
avg(index) = 1;
index = find(avg == 6);
avg(index) = 5;
for i = 1 : size(data)
    hold on
    switch avg(i)
        case 1
            plot(TIME, data(i,:),'y');
        case 2
            plot(TIME, data(i,:),'g');
        case 3
            plot(TIME, data(i,:),'r');
        case 4
            plot(TIME, data(i,:),'b');
        case 5
             plot(TIME, data(i,:),'m');
        otherwise
    end
     
end
xlabel('Time');
ylabel('Voltage / mV');
string=['ECG signal ',100];
title(string);


end

