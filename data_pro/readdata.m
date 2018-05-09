function [M,TIME,ANNOT,ATRTIME] = readdata(filename)
%read the data and annotation of MIT_BIH.
%filename 100,102,102...
%M--samples
%TIME--samples occur time
%ANNOT--annotation
%ATRTIME--

%  algorithm is based on a program written by
%  Klaus Rheinberger (University of Innsbruck)

filename = char(filename);
PATH = 'MIT-BIH';
HEADERFILE= strcat(filename,'.hea');      % .hea
ATRFILE= strcat(filename,'.atr');         % .atr
DATAFILE=strcat(filename,'.dat');         % .dat

%% deal with .hea file
heaPath = fullfile(PATH, HEADERFILE);
hea_file =fopen(heaPath,'r');
line = fgetl(hea_file);
A = sscanf(line, '%*s %d %d %d',[1,3]);
channel = A(1);
frequency = A(2);
SAMPLENUM = A(3);          %2*SAMPLENUM
for k = 1 : channel           
    line = fgetl(hea_file);
    A = sscanf(line, '%*s %d %d %d %d %d',[1,5]);
    code_format(k) = A(1);          
    gain(k) = A(2);            
    valid_bit(k) = A(3);          
    zero_line(k) = A(4);      
    firstvalue(k) = A(5);
end;
fclose(hea_file);
if code_format ~= [212,212]
    error('binary formats different to 212.');
end

%% deal with .dat file
dataPath = fullfile(PATH, DATAFILE);             % '212'
data_file = fopen(dataPath,'r');
A = fread(data_file, [3, SAMPLENUM], 'uint8')';  % matrix with 3 rows, each 8 bits long, = 2*12bit
fclose(data_file);
Ml2H = bitshift(A(:,2), -4);        
Ml1H = bitand(A(:,2), 15);          
PRL = bitshift(bitand(A(:,2),8),9);              % sign-bit
PRR = bitshift(bitand(A(:,2),128),5);            % sign-bit
M( : , 1) = bitshift(Ml1H,8)+ A(:,1)-PRL;
M( : , 2) = bitshift(Ml2H,8)+ A(:,3)-PRR;

if M(1,:) ~= firstvalue
    error('inconsistency in the first bit values');
end

M( : , 1) = (M( : , 1) - zero_line(1)) / gain(1);
M( : , 2) = (M( : , 2) - zero_line(2)) / gain(2);
TIME = (0:(SAMPLENUM-1)) / frequency;
TIME = TIME';

%% deal with .atr file
atrPath = fullfile(PATH, ATRFILE);  % attribute file with annotation data
atr_file = fopen(atrPath,'r');
A = fread(atr_file, [2, inf], 'uint8')';
fclose(atr_file);
ATRTIME = [];
ANNOT = [];
saa = size(A,1);
i = 1;
while i <= saa
    annoth = bitshift(A(i,2),-2);
    if annoth == 59
        ANNOT = [ANNOT;bitshift(A(i+3,2),-2)];
        ATRTIME=[ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
        i=i+3;
    elseif annoth==60
        % nothing to do
    elseif annoth==61
        % nothing to do
    elseif annoth==62
        % nothing to do
    elseif annoth==63
        hilfe=bitshift(bitand(A(i,2),3),8)+A(i,1);
        hilfe=hilfe+mod(hilfe,2);
        i=i+hilfe/2;
    else
        ATRTIME=[ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];
        ANNOT=[ANNOT;bitshift(A(i,2),-2)];
   end;
   i=i+1;
end;
ANNOT(length(ANNOT)) = [];       % last line = EOF (=0)
ATRTIME(length(ATRTIME)) = [];   % last line = EOF
ATRTIME= (cumsum(ATRTIME)) / frequency;

end