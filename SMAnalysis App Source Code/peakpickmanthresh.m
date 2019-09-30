function outvector=peakpickmanthresh(infile,thresh)
%Read in tab-delimited file (change the '\t' to other delimiter if
%   necessary)
indata=dlmread(infile,'\t');

%indata=indata(2:10000);

%Get columns of donor and acceptor signals
acceptor=indata(:,1);
donor=indata(:,1);

%Calculate background level from signal average
acceptorback=floor(mean(acceptor));
%donorback=floor(mean(donor));
donorb=donor;

%donorback=smooth(donor,500);
%donorback=0

acceptor=acceptor-acceptorback;
%donor=donor-donorback;

%donor=donor-donorback;
%threshdonor=196.2010;
threshdonor=thresh;
threshacceptor=thresh;



%Smooth signal
%donor=smooth(donor,1);
%acceptor=smooth(acceptor,1);

%Initialize variables
outvectordonor=zeros(0,8);
outvectoraccept=zeros(0,8);

burstlength=0;
accepttot=0;
donortot=0;
acceptormax=0;
donormax=0;


n=1;


%Green peaks
while n<=size(indata,1)
    
    if((donor(n)>threshdonor))
        burstlength=0;
        accepttot=0;
        donortot=0;
        donormax=0;

        while ((donor(n)>threshdonor)&& n<size(indata,1))
            accepttot=accepttot+acceptor(n);
            donortot=donortot+donor(n);
            burstlength=burstlength+1;
             if donor(n)>donormax
                donormax=donor(n);
            end
            n=n+1;
        end
        
        signaltot=double(accepttot+donortot);
        leakageacceptor=accepttot-donortot*(0.1);
        frettot=leakageacceptor/(donortot+leakageacceptor);
        avesignal=signaltot/burstlength;
        %makeavesignal actually be max signal
        avesignal=donormax;
        peakloc=n-ceil(burstlength/2);
        outvectortemp=horzcat(frettot,signaltot,burstlength,donortot,accepttot,leakageacceptor,avesignal,peakloc);
        outvectordonor=vertcat(outvectordonor,outvectortemp);
        donormax=0;
        
    end
    n=n+1;
    
end

n=1;
burstlength=0;
accepttot=0;
donortot=0;
%Red peaks
while n<=size(indata,1)
    
    if ((acceptor(n)>threshacceptor))
        burstlength=0;
        accepttot=0;
        donortot=0;

        while ((acceptor(n)>threshacceptor)&& n<size(indata,1))
            accepttot=accepttot+acceptor(n);
            donortot=donortot+donor(n);
            burstlength=burstlength+1;
            if acceptor(n)> acceptormax
                acceptormax=acceptor(n);
            end
            n=n+1;
        end
        
        signaltot=double(accepttot+donortot);
        leakageacceptor=accepttot-donortot*(0.1);
        frettot=leakageacceptor/(donortot+leakageacceptor);
        avesignal=signaltot/burstlength;
        %makeavesignal actually be max signal
        avesignal=acceptormax;
        peakloc=n-ceil(burstlength/2);
        outvectortemp=horzcat(frettot,signaltot,burstlength,donortot,accepttot,leakageacceptor,avesignal,peakloc);
        outvectoraccept=vertcat(outvectoraccept,outvectortemp);

    end
    n=n+1;
    
end
%acceptorrev=-acceptor;
% figure;
% hold on;
% plot(donor,'g')
 %plot(acceptorrev,'r')


matchedpeaks=0;

if ((size(outvectoraccept,1)>0)&&(size(outvectordonor,1)>0))
    
    q=1;
    tacceptor=outvectoraccept(q,8);
    found=0;
    m=1;
    
    for m=1:size(outvectordonor,1)
        tdonor=outvectordonor(m,8);
        tacceptor=outvectoraccept(q,8);
        found=0;
        
        for q=1:size(outvectoraccept,1)
            tacceptor=outvectoraccept(q,8);
            
            if ((found==0)&&(abs(tacceptor-tdonor) < 200))
                matchedpeaks=matchedpeaks+1;
                found=1;
            end
        end
    end
end

%outvector=horzcat(size(outvectordonor,1),size(outvectoraccept,1),matchedpeaks);

%outvector=horzcat(size(outvectordonor,1),mean(donorb),(std(donorb)^2/mean(donorb)));        
%outvector=horzcat(size(outvectordonor,1),size(outvectoraccept,1),mean(outvectordonor(:,7)),mean(outvectoraccept(:,7)),mean(outvectordonor(:,7)));             

outvector=horzcat(size(outvectordonor,1),mean(donorb),(std(donorb)^2/mean(donorb)),sum(outvectordonor(:,4)),mean(outvectordonor(:,7)),sum(outvectordonor(:,3))); 
%outvector=horzcat(size(outvectordonor,1),mean(donorb),(std(donorb)^2/mean(donorb)),sum(donorb),mean(outvectordonor(:,7)));
% outvector=outvectordonor   
%outvector=sortrows(outvector,-2);
%outvector=outvectordonor(:,7)'

%outvector=num2cell(outvector);
%outvecttot={'Peak Number','Mean','B Parameter','Integrated Intensity','Average Peak Height','Total Time Above Threshold'};
%outvecttot=[outvecttot;outvector];
%outpath=strcat(infile2,'peakpickuserthresh');
%xlswrite(outpath,outvecttot);