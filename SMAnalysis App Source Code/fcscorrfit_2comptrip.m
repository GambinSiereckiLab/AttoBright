function outvector=fcscorrfit_2comptrip(infile,incolumn)
%%

binning=1;
%Read in tab-delimited file (change the '\t' to other delimiter if
%   necessary)
inread=dlmread(infile,'\t');
incolumn=1;
%Choose the correct column
indata=inread(:,incolumn);

indata=indata';

%indata=indata(1:3000000);

m=ceil(length(indata)/binning);
f=zeros(1,m+1);
for n=1:length(indata)
    m=ceil(n/binning);
    f(m)=f(m)+indata(n);
end

%Calculate how many points to compute the autocorrelation for
nlags=m/10;

%The point after which the correlation should be down to 0
zerolength=nlags/2;

%Calculate the autocorrelation function
[corrcoeffs,lags]=autocorr(f,nlags,zerolength,0);
lags=lags';

lags=lags(2:size(lags));
corrcoeffs=corrcoeffs';
corrcoeffs=corrcoeffs(2:size(corrcoeffs));
lags=10*lags;
%lags=lags(7:size(lags));
%corrcoeffs=corrcoeffs(7:size(corrcoeffs));
%lags=lags/1000000;
%corrcoeffs=(corrcoeffs-min(corrcoeffs))/(max(corrcoeffs)-min(corrcoeffs));

%Fit the data with the FCSdir equation
ft=fittype('(1+(tp/(1-tp))*exp(-x/te))*g0.*(f/(1+(x/td)).*1/(1+a^(-2)*(x/td))^(1/2)+((1-f)/(1+x/t2))*1/(1+a^(-2)*(x/t2))^(1/2))+ginf');
%ft=fittype(fcsequation);
[fcsfit,gof,fitinfo]=fit(lags,corrcoeffs,ft,'StartPoint',[5,0.8,0.1,0.001,10,1000,1,0.1],'Lower',[3,0.01,0.00005,10^-6,1,1,1,10^-9],'Upper',[20,0.99,1.5,0.01,1000,10000,5,0.8]);
%plot(fcsfit,lags,corrcoeffs);

%Output fitted values in order (a,g0,ginf,td)
%outvector=coeffvalues(fcsfit);
%outvector=fitinfo.residuals;
%outvector=[corrcoeffs];
%outvector=fcsfit

%Identify outliers and exclude from fit
fitinfo;
residuals=fitinfo.residuals;
I = abs( residuals) > 50 * std( residuals );
outliers = excludedata(lags,corrcoeffs,'indices',I);
[fit2,gof,fitinfo]=fit(lags,corrcoeffs,ft,'StartPoint',[8.840,0.8,0.1,0.001,1000,10000,1,0.1],'Lower',[2,0.01,0.00005,10^-9,10,1,1,10^-9],'Upper',[100,0.99,1.5,0.01,10000,100000,1,0.1],'Exclude',outliers);

%Plot fit with points excluded
[filepath,name,ext] = fileparts(infile)
infile=name
mkdir(strcat(filepath, './','figures\'));
outpathtot=strcat(filepath, './','figures\',infile,'FCStwocomptriplet')
%% Plot your raw data (2 colours) and export to pdf
%acceptorrev=-acceptor;
figure;
hold on;
plot(fit2,lags,corrcoeffs)
ax=gca
ax.XScale = 'log'
xlabel('lags')
ylabel('autocorrelation')
title(infile)
hold off
 export_fig(outpathtot,'-pdf')

%%
%plot(fcsfit,lags,corrcoeffs)

outvector1=coeffvalues(fit2);
outvector2=gof.rmse;
outvector=[outvector1(:,1),outvector1(:,2),outvector1(:,3),outvector1(:,4),outvector1(:,6),outvector1(:,5),outvector1(:,7),outvector1(:,8),outvector2(:,1)];%outvector=fit2;
%outvector=gof.rmse;

%outvector=num2cell(outvector);
%outvecttot={'a (z0/w0)', 'Fraction Component 1' 'G0','Ginf','Component 1 Diffusion Time','Component 2 Diffusion Time','Te','Tp','r.m.s.e.'};
%outvecttot=[outvecttot;outvector];
%outpath=strcat(infile,'FCStwocomptriplet');
%xlswrite(outpath,outvecttot);


%dlmwrite('testautocorr',outvector,'delimiter','\t','newline','pc','precision','%.6f');