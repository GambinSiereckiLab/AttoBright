function plotfigraw1col(infile)
%% Import your data
indata=dlmread(infile,'\t');
[filepath,name,ext] = fileparts(infile)
infile=name
acceptor=indata(:,1);
%donor=indata(:,2);
mkdir(strcat('./','figures\'));
outpathtot=strcat('./','figures\',infile)
%% Plot your raw data (2 colours) and export to pdf
%acceptorrev=-acceptor;
figure;
hold on;
%plot(donor,'g')
plot(acceptor,'g')
xlabel('Time (ms)')
ylabel('Counts (photons/ms)')
title(infile)
hold off
 export_fig(outpathtot,'-pdf')