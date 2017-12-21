function navstats = calc_cdf_nav(nav)
%% GTT RFOn/Off CDF calculator/plotter

disp('Nav CDF Calc Start')
tic

%truthPos = [37.77345208 , -122.41787236 , -6.3070] % antenna 4
truthPos = [37.773484953, -122.417716503, -5.606] % antenna 2
refElips = referenceEllipsoid('grs80')
falseFixthreshold = 0.25

[nav.errN, nav.errE, nav.errD] = geodetic2ned(nav.Lat_deg_,nav.Lon_deg_,nav.AltEllips_m_,...
    truthPos(1), truthPos(2), truthPos(3), refElips);
        
   
nav.errHoriz = (nav.errN.^2 + nav.errE.^2).^0.5;
nav.err3D = (nav.errN.^2 + nav.errE.^2 + nav.errD.^2).^0.5;
        

%% calc horiz err CDF for all epochs

vi = nav.FixMode ~=0;

cdfallepochs = sort(abs(nav.errHoriz(vi)));
cdf3Dallepochs = sort(abs(nav.err3D(vi)));


n = length(cdfallepochs);
navstats.count.allEpochs = n;
[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));


navstats.allEpochs_errHoriz = [cdfallepochs(sig1); cdfallepochs(sig2); cdfallepochs(sig3);n];
navstats.allEpochs_err3D = [cdf3Dallepochs(sig1); cdf3Dallepochs(sig2); cdf3Dallepochs(sig3);n];
navstats.plotdata.allEpochs_errHoriz= cdfallepochs;
navstats.plotdata.allEpochs_err3D = cdf3Dallepochs;

%% calc horiz error cdf values for RTK fixed epochs
vi = nav.FixMode == 4;

cdfRTKfixed = sort(abs(nav.errHoriz(vi)));
cdf3DRTKfixed = sort(abs(nav.err3D(vi)));

n = length(cdfRTKfixed);
navstats.count.RTKfixed = n;
[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

navstats.RTKfixed_errHoriz = [cdfRTKfixed(sig1); cdfRTKfixed(sig2); cdfRTKfixed(sig3); n];
navstats.RTKfixed_err3D = [cdf3DRTKfixed(sig1); cdf3DRTKfixed(sig2); cdf3DRTKfixed(sig3); n];
navstats.plotdata.RTKfixed_errHoriz = cdfRTKfixed;
navstats.plotdata.RTKfixed_err3D = cdf3DRTKfixed;

%% calc horiz error cdf values for RTK float epochs

vi = nav.FixMode == 3;

cdfRTKfloat = sort(abs(nav.errHoriz(vi)));
cdf3DRTKfloat = sort(abs(nav.err3D(vi)));

n = length(cdfRTKfloat);

navstats.count.RTKfloat = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

navstats.RTKfloat_errHoriz = [cdfRTKfloat(sig1); cdfRTKfloat(sig2); cdfRTKfloat(sig3); n];
navstats.RTKfloat_err3D = [cdf3DRTKfloat(sig1); cdf3DRTKfloat(sig2); cdf3DRTKfloat(sig3); n];
navstats.plotdata.RTKfloat_errHoriz = cdfRTKfloat;
navstats.plotdata.RTKfloat_err3D = cdf3DRTKfloat;

%% calc horiz error cdf values for code diff epochs

vi = nav.FixMode == 2;

cdfDGNSS = sort(abs(nav.errHoriz(vi)));
cdf3DDGNSS = sort(abs(nav.err3D(vi)));

n = length(cdfDGNSS);

navstats.count.DGNSS = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

navstats.DGNSS_horiz = [cdfDGNSS(sig1); cdfDGNSS(sig2); cdfDGNSS(sig3)];
navstats.DGNSS_3D = [cdf3DDGNSS(sig1); cdf3DDGNSS(sig2); cdf3DDGNSS(sig3)];

navstats.plotdata.DGNSS_errHoriz = cdfDGNSS;
navstats.plotdata.DGNSS_err3D = cdf3DDGNSS;
%% calc horiz error cdf values for SPS epochs
vi = nav.FixMode == 1;

cdfsps = sort(abs(nav.errHoriz(vi)));
cdf3dsps = sort(abs(nav.errHoriz(vi)));

n = length(cdfsps);

navstats.count.SPS = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

navstats.SPS_horiz = [cdfsps(sig1); cdfsps(sig2); cdfsps(sig3)];
navstats.SPS_3D = [cdf3dsps(sig1); cdf3dsps(sig2); cdf3dsps(sig3)];

navstats.plotdata.SPS_errHoriz = cdfsps;
navstats.plotdata.SPS_err3D = cdf3dsps;

%% calc horiz error with all SPS and Code Diff Epochs


vi = nav.FixMode <= 2 & nav.FixMode ~=0;

%if isempty(vi) == 0
    
    cdfnortk = sort(abs(nav.errHoriz(vi)));
    cdf3dnortk = sort(abs(nav.err3D(vi)));
    
    n = length(cdfnortk);
    navstats.count.noRTK = n;
    
    [~, sig1] = min(abs((1:n)/n-0.68));
    [~, sig2] = min(abs((1:n)/n-0.95));
    [~, sig3] = min(abs((1:n)/n-0.9975));

    navstats.noRTK_errhoriz = [cdfnortk(sig1); cdfnortk(sig2); cdfnortk(sig3); n];
    navstats.noRTK_err3D = [cdf3dnortk(sig1); cdf3dnortk(sig2); cdf3dnortk(sig3); n];


    navstats.plotdata.noRTK_errHoriz = cdfnortk;
    navstats.plotdata.noRTK_err3D = cdf3dnortk;
%end

%% calc horiz error for all RTK epochs
vi = nav.FixMode >=3;

cdfallrtk = sort(abs(nav.errHoriz(vi)));
cdf3dallrtk = sort(abs(nav.err3D(vi)));

n = length(cdfallrtk);
navstats.count.allRTK = n;

[~, sig1] = min(abs((1:n)/n-0.68));
[~, sig2] = min(abs((1:n)/n-0.95));
[~, sig3] = min(abs((1:n)/n-0.9975));

navstats.allRTK_fixed_errHoriz = [cdfallrtk(sig1); cdfallrtk(sig2); cdfallrtk(sig3); n];
navstats.allRTK_err3D = [cdf3dallrtk(sig1); cdf3dallrtk(sig2); cdf3dallrtk(sig3); n];
navstats.plotdata.allRTK_errHoriz = cdfallrtk;
navstats.plotdata.allRTK_err3D = cdf3dallrtk;

toc



%%


