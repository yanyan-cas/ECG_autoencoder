function [wdata,labels] = extractdata(ds)
% Each of the 48 records is slightly over 30 minutes long and 650000 samples
% according to our count, There are 112551 annotations,so that each beat has
% about 277 samples. To get more information ,We aloud part of overlap and 
% define a window with length of 340 data points(the R peak of the wave is
% located at 141th point)
frequency = 360;
% init param
wdata = [];
labels = [];
switch ds  % switch the dataset: 1--44 records 2-- 7 long term records
    case 1 
        % 23 records chosen at random from this set
        % {'100';'101';'102';'103';'104';'105';'106';'107';'108';'109';'111';'112';'113';'114';'115';...
        %     '116';'117';'118';'119';'121';'122';'123';'124'};
        % 25 records selected from the same set to include a variety of rare but clinically important phenomena
        % that would not be well-represented by a small random sample of Holter recordings.
        % {'200';'201';'202';'203';'205';'207';'208';'209';'210';'212';'213';'214';'215';'217';'219';...
        %     '220';'221';'222';'223';'228';'230';'231';'232';'233';'234'};
        % remove the 102 104 107 217 record
        dataset = {'100';'101';'103';'105';'106';'108';'109';'111';'112';'113';'114';'115';...
        '116';'117';'118';'119';'121';'122';'123';'124';'200';'201';'202';'203';'205';'207';'208';'209';...
        '210';'212';'213';'214';'215';'219';'220';'221';'222';'223';'228';'230';'231';'232';'233';'234'};
        folder = 'MIT-BIH_mat';
    case 2
        % seven long_tern records 
        dataset = {'14046';'14134';'14149';'14157';'14172';'14184';'15814'};
        folder = 'MIT-LT_mat';
    otherwise
        return;
end

% data in the mar file
% M--samples
% TIME--samples occur time
% ANNOT--annotation
% ATRTIME--corresponding annotation time
%%-------------------------------------------------------------------------
% loading data and divide into window with label
for i = 1 : size(dataset,1)
    wave = [];
    filename = dataset{i};
    marfile = strcat(filename,'.mat');
    marfile = fullfile(folder,marfile); % get the full path of the file
    load(marfile);
    if ds == 2                          % resample the second database to 360
        data = resample(M(:,1),360,128);
    else
        data = M(:,1);
    end
    data = data_filter(data,frequency); % butter high pass filter 
    norm_data = normalize(data);        % normalize the data to [0,1]
    Rtime = round(frequency * ATRTIME(4:size(ATRTIME,1)-1,1));
    annot = ANNOT(4:size(ANNOT,1)-1,1);
    [frm_annot, filter_time] = annot_filter(annot,Rtime); % remove the labels not used
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
    labels = [labels, frm_annot(2:end-1)'];
end
%%-------------------------------------------------------------------------

end



