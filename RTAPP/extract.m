function [wdata,labels] = extract()
% Each of the  records is slightly over 30 minutes long and 650000 samples
% e a window with length of 340 data points(the R peak of the wave is
% located at 141th point)
frequency = 360;
% init param
wdata = [];
labels = [];
dataset = {'215'};
% data in the mar file
% M--samples
% TIME--samples occur time
% ANNOT--annotation
% ATRTIME--corresponding annotation time
%%-------------------------------------------------------------------------
% loading data and divide into window with label
folder = '';
for i = 1 : size(dataset,1)
    wave = [];
    filename = dataset{i};
    marfile = strcat(filename,'.mat');
    marfile = fullfile(folder,marfile); % get the full path of the file
    load(marfile);
    data = M(:,1);
    data = data_filter(data,frequency); % butter high pass filter 
    norm_data = normalize(data);        % normalize the data to [0,1]
    Rtime = round(frequency * ATRTIME(4:size(ATRTIME,1)-1,1));
    annot = ANNOT(4:size(ANNOT,1)-1,1);
    [frm_annot,filter_time] = annot_filter(annot,Rtime); % remove the labels not used
    for j = 2 : size(filter_time,1)-1   % split data to windows
        tmp = zeros(340,1);
        pos_time = filter_time(j+1) - filter_time(j);
        pre_time = filter_time(j) - filter_time(j - 1);
        if  pos_time < 300 || pre_time < 280
            tmp = adaptWind(filter_time(j),pre_time,pos_time,norm_data);
        else
            tmp = norm_data(filter_time(j)-140 : filter_time(j)+199,1);
        end
        wave = [wave,tmp];       
    end
    wdata = [wdata, wave];
    labels = [labels,frm_annot(2:end-1)'];
end
%%-------------------------------------------------------------------------

end




