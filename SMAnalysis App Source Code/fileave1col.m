function outvector=fileave1col(infile) 
%function to calculate the average of the green and red fluorescence
%   channels in microscope data
%Input:
%infile is the path to the input file
%
%Output:
%outvector is a 1x2 vector with the green channel and red channel
%   fluorescence


%Read in tab-delimited file (change the '\t' to other delimiter if
%   necessary)
indata=dlmread(infile,'\t');

%Get columns of donor and acceptor signals
acceptor=indata(:,1);
%donor=indata(:,2);

%Smooth signal

%donorback=smooth(donor,500);
%acceptorback=smooth(acceptor,500);

%donor=donor-donorback;
%acceptor=acceptor-acceptorback;

%acceptor=acceptor(1:1000);
%donor=donor(1:1000);

%Calculate background level from signal average
acceptormean=mean(acceptor);
%donormean=mean(donor);

%donorstdev=std(donor);
acceptorstdev=std(acceptor);

%donorskew=(std(donor)^2)/mean(donor);
acceptorskew=(std(acceptor)^2)/mean(acceptor);

%donormode=mode(donor);
acceptormode=mode(acceptor);

acceptorbrightness=((std(acceptor)^2)/mean(acceptor))-1;

outvector=[acceptormean, acceptorstdev,acceptormode,acceptorskew,acceptorbrightness];
%outvector=num2cell(outvector);
%outvecttot={'Average Signal','StDev','Mode','B Parameter','Brightness'};
%outvecttot=[outvecttot;outvector];
%outpath=strcat(infile2,'brightness');
%xlswrite(outpath,outvecttot);