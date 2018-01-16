function [rxdata] = getReceiverData(dut_foldername)

% regular expression tokens
exFW = 'Firmware Version';
exAnt = 'Antenna';
exLJID = 'LabJack';

    fn = dut_foldername
    
    if strcmp(fn(end), '/') == false
        fn = strcat(fn, '/')
    end
    
    rptID = fopen(strcat(fn, 'report.txt'))
    
    a = textscan(rptID, '%s', 100000, 'delimiter', '\n');
    a = a{:};
    
    for j = 1:length(a)
        
        if regexp(a{j}, exFW) == true
            
            x = strsplit(a{j}, ':')
            
            rxdata.FWRev = x{2};
            
        elseif regexp(a{j}, exAnt) == true
            
            x = strsplit(a{j}, ' ');
            x = str2double(x);
            rxdata.truthPos = [x(4), x(6), x(8)];
            
        elseif regexp(a{j}, exLJID) == true
            
            x = strsplit(a{j}, ' ')
            rxdata.gtID = str2double(x{3});
            rxdata.gtname = strcat('GT', x{3});
            
            
        end
        
    end
   

 fclose('all');
