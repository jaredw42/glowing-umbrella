%% gt_createSheetData
try testType
    
if testType == 'RF'
    
    for i = 1:nDevices
        %% time to fix stats
        rfonoffstats = GTT(i).rfonoffstats
        
        sData(1:3,i) =  rfonoffstats.TTSPS;
        sData(4:5,i) = NaN;
        sData(6:8,i) = rfonoffstats.TTFloat;
        sData(9:10,i) = NaN;
        sData(11:13,i) = rfonoffstats.TTFixed;
               
    end   
elseif testType == 'ST'
    for i = 1:nDevices
        ststats = GTT(i).startstats
        sData(1:3,i) = ststats.TTBoot;
        sData(6:8,i) = ststats.TTSPS;
        sData(11:13,i) = ststats.TTFloat;
        sData(16:18,i) = ststats.TTFixed;
    end
    
end

catch
    disp('No test type detected')
end

%% nav stats 
    %% horiz error data
    for i = 1:nDevices
    navstats = GTT(i).navstats;
    navdata(1:4,i) = navstats.allEpochs_errHoriz;
    navdata(7:10,i) = navstats.allRTK_errHoriz;
    navdata(13:16,i) = navstats.noRTK_errHoriz;
    navdata(19:22,i) = navstats.RTKfixed_errHoriz;
    navdata(25:28,i) = navstats.RTKfloat_errHoriz;
    navdata(31:34,i) = navstats.DGNSS_errHoriz;
    navdata(37:40,i) = navstats.SPS_errHoriz;
    
    %% 3D Error data
    
    navdata(44:47,i) = navstats.allEpochs_err3D;
    navdata(50:53,i) = navstats.allRTK_err3D;
    navdata(56:59,i) = navstats.noRTK_err3D;
    navdata(62:65,i) = navstats.RTKfixed_err3D;
    navdata(68:71,i) = navstats.RTKfloat_err3D;
    navdata(74:77,i) = navstats.DGNSS_err3D;
    navdata(80:83,i) = navstats.SPS_err3D;
    
    end
    
    
    
        