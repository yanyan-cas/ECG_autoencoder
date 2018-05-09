function [M,ATRTIME] = H_data_reader( filename,n )
%read the data and RR of ECG data.
%filename
%M--samples
%TIME--samples occur time
%ANNOT--annotation
%ATRTIME--

PATH = 'H-Data';
filename = char(filename);
INFFILE= strcat(filename,'.inf');      % .inf
RRFILE= strcat(filename,'.rr');        % .rr
DATAFILE=strcat(filename,'.pd');       % .dat
section_time = 1800;
start_time  = (n -1) * section_time;
%% deal with .inf file
infPath = fullfile(PATH, INFFILE);
inf_file =fopen(infPath,'r');
A = textscan(inf_file,'%*s %d',1,'HeaderLines',8);
frequency = A{1};
fgetl(inf_file);
line = fgetl(inf_file);
channel = sscanf(line, '%*s %d',[1]);
line = fgetl(inf_file);
HitBytes = sscanf(line, '%*s %d',[1]);
line = fgetl(inf_file);
ADC  = sscanf(line, '%*s %d',[1]);
line = fgetl(inf_file);
ADCZero  = sscanf(line, '%*s %d',[1]);
fclose(inf_file);
if channel ~= 3
    error('binary formats are different.');
end

%% deal with .dat file
dataPath = fullfile(PATH, DATAFILE);
data_file = fopen(dataPath,'r');
offset = 3 * start_time * frequency + 95;
size = 3 * section_time * frequency;
sp = fseek(data_file,offset,0);
if sp == 0
    M3 = fread(data_file,size,'uint8');
    index = 1 : size / 3;
    index = 3 * index;
    M = M3(index,1);
    if n == 1
    index = find(M(1:200,1) == 0);
    M(index,1) = ADCZero;
    end
    M( : , 1) = (M( : , 1) - ADCZero) / ADC;
else
    M = [];
end
fclose(data_file);

%% deal with .RR file
RRPath = fullfile(PATH, RRFILE);      % attribute file with annotation data
rr_file = fopen(RRPath,'r');
A = textscan(rr_file,'%*s %*s %d');
TIME = A{1}';
RRend = TIME(numel(TIME));
index1 = find(TIME < start_time * 1000);
index2 = find(TIME < n * section_time * 1000);
begin = numel(index1) + 1;
en = numel(index2);
if begin > en
   M = []; 
   ATRTIME = [];
else
   ATRTIME = double(TIME(1,begin:en));
   ATRTIME = ATRTIME  - start_time * 1000;   
end        
fclose(rr_file);

end

