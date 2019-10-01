function outvector=Brightness(infile) 
%function to calculate the average of the green and red fluorescence
%   channels in microscope data
%Input:
%infile is the path to the input file
%
%Output:
%outvector is [datamean,datastdev,datamode,databvalue,databrightness]

%Read in tab-delimited file (change the '\t' to other delimiter if
%   necessary)
indata=dlmread(infile,'\t');

%Get columns of donor and acceptor signals
data=indata(:,1);

%Calculate background level from signal average
datamean=mean(data);

datastdev=std(data);

databvalue=(std(data)^2)/mean(data);

databrightness=databvalue-1;

datamode=mode(data);

outvector=[datamean,datastdev,datamode,databvalue,databrightness];

outpathtot=strcat(infile,'_averagesignal');
xlswrite(outpathtot,outvector);

