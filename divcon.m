%% loading data from MIT-BIH arrythmia database
[wdata,labels] = extractdata(1);        % get data in window of 340 and labels
labels = remap_labels(labels);          % remap labels to 1 - 5
dataSize = size(wdata,2);
m = randperm(dataSize);                 % generate a random permition 
aeindex = m(1:floor(dataSize/2));
othindex = m(floor(dataSize/2)+1:end);
unlabeledData = wdata(:,aeindex);       % randomly pick half data to train deep network
othdata = wdata(:,othindex);
othlabels = labels(:,othindex);
clear wdata labels
testSet = othdata(:,1:floor(dataSize/6));   % 1/3 of left data as testing data
testlabels = othlabels(:,1:floor(dataSize/6));
trainSet = othdata(:,floor(dataSize/6)+1:end);% 2/3 as fine-tuning data
trainlabels = othlabels(:,floor(dataSize/6)+1:end);
clear aeindex othindex othdata othlabels m dataSize 

%% loading data from MIT LONG TERM ECG database
% [wdata,labels] = extractdata(2);
% labels = remap_labels(labels);
% dataSize = size(wdata,2);
% m = randperm(dataSize);
% testSet = [testSet,wdata(:,m(1:30000))];    % randomly pick 30000 windows as testing data
% testlabels = [testlabels,labels(:,m(1:30000))];
% trainSet = [trainSet,wdata(:,m(30001:80000))]; % 50000 as fine-tuning data
% trainlabels = [trainlabels,labels(:,m(30001:80000))];
% unlabeledData = [unlabeledData,wdata(:, m(80001:end))];% the left data used to training the deep network
% clear wdata labels othdata othlabels m dataSize