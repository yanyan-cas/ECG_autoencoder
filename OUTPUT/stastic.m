folder = 'H-Data/';
path = strcat(folder,'*.pd');
files = dir(path);
len = length(files);
%Datafiles = cell(len,1);
count_n = 0;
count_s = 0;
count_v = 0;
count_f = 0;
count_q = 0;
count_all = 0;
for i = 1 :len
    %str = regexp(files(1).name,'.','split');
     [PATHSTR,NAME,EXT] = fileparts(files(i).name);
     %Datafiles{i} = NAME;
     [labels] = h_reader(NAME);          %reading the data and RR file
     count_all = count_all + numel(labels);
     for j = 1: numel(labels)
         switch labels{j}
             case 'N'
                 count_n = count_n + 1;
             case 'S'
                 count_s = count_s + 1;
             case 'V'
                 count_v = count_v + 1;
             case 'F'
                 count_f = count_f + 1;
             case 'Q'
                 count_q = chount_q + 1;
             otherwise
         end
     end                 
end