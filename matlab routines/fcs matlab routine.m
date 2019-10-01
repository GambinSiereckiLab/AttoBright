function outvector=fcscorrfit(infile);
%Code to fit data from input file to FCS autocorrelation curve
%Inputs: 
%infile is the path to the input file
%incolumn is the column to use for the analysis (e.g. 1 = Red/Acceptor channel,
%   2 = Green/Donor channel) - for the Nanobright this is column 1 but this
%   has been kept as it may be useful for analysis of data from other
%   sources
%binning is the time binning of the data to use - this is automatically set
%to 1
%
%Output:
%outvector is a list of the fitted parameters from the analysis
incolumn=1;
binning=1;
%Read in tab-delimited file (change the '\t' to other delimiter if
%   necessary)
inread=dlmread(infile,'\t');

%Choose the correct column
indata=inread(:,incolumn);

indata=indata';

m=ceil(length(indata)/binning);
f=zeros(1,m+1);
for n=1:length(indata)
    m=ceil(n/binning);
    f(m)=f(m)+indata(n);
end

%Calculate how many points to compute the autocorrelation for
nlags=m/100;

%The point after which the correlation should be down to 0
zerolength=nlags/2;

%Calculate the autocorrelation function
[corrcoeffs,lags]=autocorr(f,nlags,zerolength,0);
lags=lags';

%remove first point as can be affected by antibunching, reformat data
lags=lags(2 :size(lags));
corrcoeffs=corrcoeffs';
corrcoeffs=corrcoeffs(2:size(corrcoeffs));
lags=10*lags; %this assumes 10us time bins to convert to us

%Fit the data with the FCS equation
ft=fittype('(1+(tp/(1-tp))*exp(-x/te))*g0./((1+(x/td)).*(1+a^(-2)*(x/td))^(1/2))+ginf');
%ft=fittype(fcsequation);
[fcsfit,gof,fitinfo]=fit(lags,corrcoeffs,ft,'StartPoint',[4.7,0.3,0.001,1000,10,0.1],'Lower',[2,0.00005,10^-6,1,10^-6,10^-9],'Upper',[10,1.5,0.01,100000,25,0.5]);
%plot(fcsfit,lags,corrcoeffs);

%Identify outliers and exclude from fit - if nothing's gone wrong there
%shouldn't be any. Only if e.g. forget to exclude first lag ^^
fitinfo;
residuals=fitinfo.residuals;
I = abs( residuals) > 50 * std( residuals );
outliers = excludedata(lags,corrcoeffs,'indices',I);
[fit2,gof,fitinfo] = fit(lags,corrcoeffs,ft,'StartPoint',[3,0.3,0.001,100,1,0.1],'Lower',[2,0.00005,10^-8,1,10^-6,10^-9],'Upper',[10,1.5,0.1,100000,20,0.2],'Exclude',outliers);

%Plot fit with points excluded
figure;
plot(fit2,lags,corrcoeffs);
ax=gca;
ax.XScale = 'log';
xlabel('lags');
ylabel('autocorrelation');
title(infile, 'Interpreter','none' );
hold off;

%get coefficients and calculate rmse
outvector1=coeffvalues(fit2);
outvector2=gof.rmse;

%(a,G0,Ginf,tD,Tp,Te,rmse)
outvector=[outvector1(:,1),outvector1(:,2),outvector1(:,3),outvector1(:,4),outvector1(:,5),outvector1(:,6),outvector2(:,1)];

%outvector=fit2; %use this to get errors in fitted parameters

%USE THIS TO CALCULATE CONFOCAL VOLUME USING FREE ALEXA-568
%D=332e-12;
%wo=sqrt(4*outvector1(:,4)*10^(-6)*D);
%Veff=(wo^3)*outvector1(:,1)*pi^(3/2)*1000;
%outvector=[outvector1(:,1),outvector1(:,2),outvector1(:,3),outvector1(:,4),outvector1(:,5),outvector1(:,6),outvector2(:,1),Veff];


dlmwrite(strcat(infile,'_autocorr'),outvector,'delimiter','\t','newline','pc','precision','%.6f');