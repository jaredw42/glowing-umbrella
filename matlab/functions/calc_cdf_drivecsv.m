 
function [cdfStats] = calc_cdf_drivecsv(myStruct)

% expects a struct with horizontal and 3d errors calculated and
% differential mode.  finds valid indicies based on fixMode and calculates
% 2 and 3D statistics for each differential mode as well as combined RTK
% and combined non-RTK epochs.  

errHoriz = myStruct.errHoriz;
err3D = myStruct.err3D;

try 
fixMode = myStruct.fixmode;

catch
    fixMode = myStruct.FixMode;
end



%% calc horiz err CDF for all epochs

vi = fixMode > 0;
cdfallepochs = sort(abs(errHoriz(vi)));
cdf3Dallepochs = sort(abs(err3D(vi)));

n = length(cdfallepochs);
cdfStats.all_count = n;
[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));


cdfStats.all_horiz = [cdfallepochs(sig1); cdfallepochs(sig2); cdfallepochs(sig3);n];
cdfStats.all_3D = [cdf3Dallepochs(sig1); cdf3Dallepochs(sig2); cdf3Dallepochs(sig3);n];

cdfStats.all_horiz_plotdata = cdfallepochs;
cdfStats.all_3D_plotdata = cdf3Dallepochs;

%% calc horiz error cdf values for RTK fixed epochs
%vi = fixMode == 'integer_rtk';
vi = fixMode == 4;

cdfRTKfixed = sort(abs(errHoriz(vi)));
cdf3DRTKfixed = sort(abs(err3D(vi)));

n = length(cdfRTKfixed);
cdfStats.RTKfixed_count = n;
[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

cdfStats.RTKfixed_horiz = [cdfRTKfixed(sig1); cdfRTKfixed(sig2); cdfRTKfixed(sig3); n];
cdfStats.RTKfixed_3D = [cdf3DRTKfixed(sig1); cdf3DRTKfixed(sig2); cdf3DRTKfixed(sig3);n];
cdfStats.RTKfixed_horiz_plotdata = cdfRTKfixed;
cdfStats.RTKfixed_3D_plotdata = cdf3DRTKfixed;

%% calc horiz error cdf values for RTK float epochs

%vi = fixMode == 'float_rtk';
vi = fixMode == 3;

cdfRTKfloat = sort(abs(errHoriz(vi)));
cdf3DRTKfloat = sort(abs(err3D(vi)));

n = length(cdfRTKfloat);

cdfStats.RTKfloat_count = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

cdfStats.RTKfloat_horiz = [cdfRTKfloat(sig1); cdfRTKfloat(sig2); cdfRTKfloat(sig3); n];
cdfStats.RTKfloat_3D = [cdf3DRTKfloat(sig1); cdf3DRTKfloat(sig2); cdf3DRTKfloat(sig3); n];
cdfStats.RTKfloat_horiz_plotdata = cdfRTKfloat;
cdfStats.RTKfloat_3D_plotdata = cdf3DRTKfloat;

%% calc horiz error cdf values for code diff epochs

vi = fixMode == 2;

cdfDGNSS = sort(abs(errHoriz(vi)));
cdf3DDGNSS = sort(abs(err3D(vi)));

n = length(cdfDGNSS);

cdfStats.DGNSS_count = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

cdfStats.DGNSS_horiz = [cdfDGNSS(sig1); cdfDGNSS(sig2); cdfDGNSS(sig3)];
cdfStats.DGNSS_3D = [cdf3DDGNSS(sig1); cdf3DDGNSS(sig2); cdf3DDGNSS(sig3)];

cdfStats.DGNSS_horiz_plotdata = cdfDGNSS;
cdfStats.DGNSS_3D_plotdata = cdf3DDGNSS;
%% calc horiz error cdf values for SPS epochs

%vi = fixMode == 'spp_fix';
vi = fixMode == 1;

cdfsps = sort(abs(errHoriz(vi)));
cdf3dsps = sort(abs(errHoriz(vi)));

n = length(cdfsps)

cdfStats.SPS_count = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

cdfStats.SPS_horiz = [cdfsps(sig1); cdfsps(sig2); cdfsps(sig3)];
cdfStats.SPS_3D = [cdf3dsps(sig1); cdf3dsps(sig2); cdf3dsps(sig3)];

cdfStats.SPS_horiz_plotdata = cdfsps;
cdfStats.SPS_3D_plotdata = cdf3dsps;

%% calc horiz error with all SPS and Code Diff Epochs


vi = fixMode <= 2;

if isempty(vi) == 0
    
    cdfnortk = sort(abs(errHoriz(vi)));
    cdf3dnortk = sort(abs(err3D(vi)));
    
    n = length(cdfnortk);
    cdfStats.NO_RTK_fixed_count = n;
    
    [~, sig1] = min(abs((1:n)/n-0.68));
    [~, sig2] = min(abs((1:n)/n-0.95));
    [~, sig3] = min(abs((1:n)/n-0.9975));

    cdfStats.NO_RTK_horiz = [cdfnortk(sig1); cdfnortk(sig2); cdfnortk(sig3); n];
    cdfStats.NO_RTK_3D = [cdf3dnortk(sig1); cdf3dnortk(sig2); cdf3dnortk(sig3); n];


    cdfStats.NO_RTK_horiz_plotdata = cdfnortk;
    cdfStats.NO_RTK_3D_plotdata = cdf3dnortk;
end

%% calc horiz error for all RTK epochs

%vi = fixMode =='integer_rtk' | fixMode=='float_rtk';
vi = fixMode >=3;


cdfallrtk = sort(abs(errHoriz(vi)));
cdf3dallrtk = sort(abs(err3D(vi)));

n = length(cdfallrtk);
cdfStats.ALL_RTK_count = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

cdfStats.ALL_RTK_fixed_horiz = [cdfallrtk(sig1); cdfallrtk(sig2); cdfallrtk(sig3); n];
cdfStats.ALL_RTK_fixed_3D = [cdf3dallrtk(sig1); cdf3dallrtk(sig2); cdf3dallrtk(sig3);n];


cdfStats.ALL_RTK_horiz_plotdata = cdfallrtk;
cdfStats.ALL_RTK_3D_plotdata = cdf3dallrtk;




