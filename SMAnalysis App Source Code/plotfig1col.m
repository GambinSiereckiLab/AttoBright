function outvector=plotfig1col(infile,bins2) 
%%
indata=dlmread(infile,'\t');

%Get columns of donor and acceptor signals\
acceptor=indata(:,1);
%acceptor=acceptor(5000:12003900);
%donor=indata(:,2);

acceptor=indata(:,1);
%donor=indata(:,2);

[filepath,name,ext] = fileparts(infile)
name=name
filepath=filepath
outpathtot=strcat(filepath,'/figures/',name,' histogram')
 %% Plot
 figure;
hold on;
h= histogram(acceptor,'BinWidth',bins2)
h.FaceColor='g'
h.EdgeColor='g'
set(gca,'YScale','log')
xlabel('Counts (photons/ms)')
ylabel('Occurance')
title([name, ' histogram'])
hold off
% 
 export_fig(outpathtot,'-pdf','-append')
% export_fig test.pdf -append