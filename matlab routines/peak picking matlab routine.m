function outvector=PeakPick(infile2,thresh2) 
            % hObject    handle to pushbutton1 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
               
        
            %Read in tab-delimited file (change the '\t' to other delimiter if
            %   necessary)
            indata=dlmread(infile2,'\t');
            
            %Get columns of signal
            data=indata(:,1);
            threshdata=thresh2; 
            datab=data;
            %Calculate and subtract background level using signal average (uncomment if
            %necessary)
            %databack=floor(mean(data));
            %data=data-databack;
                      
            
            %Initialize variables
            outvectordata=zeros(0,8);
            
            burstlength=0;
            datatot=0;
            datamax=0;
            
            
            n=1;
                        
            %Pick peaks
            while n<=size(indata,1)
            
                if((data(n)>threshdata))
                    burstlength=0;
                    datatot=0;
                    datamax=0;
            
                    while ((data(n)>threshdata)&& n<size(indata,1))
                        datatot=datatot+data(n);
                        burstlength=burstlength+1;
                         if data(n)>datamax
                            datamax=data(n);
                        end
                        n=n+1;
                    end
            
                    %avesignal=datatot/burstlength;
                    %makeavesignal actually be max signal
                    avesignal=datamax;
                    peakloc=n-ceil(burstlength/2);
                    outvectortemp=horzcat(burstlength,datatot,avesignal,peakloc);
                    outvectordata=vertcat(outvectordata,outvectortemp);
                    datamax=0;
            
                end
                n=n+1;
            
            end

            outvector=horzcat(size(outvectordata,1),mean(datab),(std(datab)^2/mean(datab)),sum(outvectordata(:,2)),mean(outvectordata(:,3)),sum(outvectordata(:,1)));

            
            outvector=num2cell(outvector);
            outvecttot={'Peak Number','Mean','B Parameter','Integrated Intensity','Average Peak Height','Total Time Above Threshold'};
            outvector=[outvecttot;outvector];
            outpath=strcat(infile2,'_peakpickuserthresh');
            xlswrite(outpath,outvector);
        end