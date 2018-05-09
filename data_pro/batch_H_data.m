function [data] = batch_H_data(n)
%  A batch has each person's 30 minus ECG
%  One batch has about 200000 windows
%  n = 1 ,we get the first 30m ECG of each person, n = 2,we get the next
%  30m ans so on.
%  Get read all the file name of ECG files
%  n = 1;
folder = 'H-Data/';
path = strcat(folder,'*.pd');
files = dir(path);
len = length(files);
%  Datafiles = cell(len,1);
data = [];
frequency = 128;
for i = 1 :len
    % str = regexp(files(1).name,'.','split');
     [PATHSTR,NAME,EXT] = fileparts(files(i).name);
     % Datafiles{i} = NAME;
     [M,ATRTIME] = H_data_reader(NAME,n);          % reading the data and RR file
     sdata = Hsplit(M,ATRTIME',frequency);         % split the data to window of 340 sample according to R marks
     data = [data,sdata];
end
%%-------------------------------------------------------------------------
