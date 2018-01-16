function [rfonoffstats] = calc_cdf_rfonoff(rfonoff, testType)
%% GTT RFOn/Off CDF calculator/plotter

disp('RF On/Off CDF Calc Start')
tic
      

    ttfixcdf = sort(rfonoff.TTSPS_s_);
    max2derrcdf = sort(rfonoff.SPS2DError_m_);
    max3derrcdf = sort(rfonoff.SPS3DError_m_);
    n = length(ttfixcdf);

    [~, sig1] = min(abs((1:n)/n-0.68));
    [~, sig2] = min(abs((1:n)/n-0.95));
    [~, sig3] = min(abs((1:n)/n-0.9975));
    
    rfonoffstats.plotdata.TTSPSs= ttfixcdf;   
    rfonoffstats.plotdata.Max2DSPSErr = max2derrcdf;
    rfonoffstats.plotdata.Max3DSPSErr = max3derrcdf;
    rfonoffstats.TTSPS = [ttfixcdf(sig1); ttfixcdf(sig2); ttfixcdf(sig3)];
    rfonoffstats.Max2DSPSStats = [max2derrcdf(sig1); max2derrcdf(sig2); max2derrcdf(sig3)];
    rfonoffstats.Max3DSPSStats = [max3derrcdf(sig1); max3derrcdf(sig2); max3derrcdf(sig3)];
    
    try testType == 'ST'
        ttboot = sort(rfonoff.TTBoot_s_);
        rfonoffstats.plotdata.TTBoot = ttboot;
        rfonoffstats.TTBoot = [ttboot(sig1); ttboot(sig2); ttboot(sig3);]
    end
    
%% calc time to fix RTK CDFs 


    ttfixcdf = sort(rfonoff.TTFloat_s_);
    max2derrcdf = sort(rfonoff.Float2DError_m_);
    max3derrcdf = sort(rfonoff.Float3DError_m_);
    
    n = length(ttfixcdf);
    
    [~, sig1] = min(abs((1:n)/n-0.68));
    [~, sig2] = min(abs((1:n)/n-0.95));
    [~, sig3] = min(abs((1:n)/n-0.9975));
    
    rfonoffstats.plotdata.TTFloats = ttfixcdf;
    rfonoffstats.plotdata.Max2DFloatErr = max2derrcdf;
    rfonoffstats.plotdata.Max3DFloatErr = max3derrcdf;
    rfonoffstats.TTFloat = [ttfixcdf(sig1); ttfixcdf(sig2); ttfixcdf(sig3)];
    rfonoffstats.Max2DFloatStats = [max2derrcdf(sig1); max2derrcdf(sig2); max2derrcdf(sig3)];
    rfonoffstats.Max3DFloatStats = [max3derrcdf(sig1); max3derrcdf(sig2); max3derrcdf(sig3)];

    ttfixcdf = sort(rfonoff.TTFixed_s_);
    max2derrcdf = sort(rfonoff.Fixed2DError_m_);
    max3derrcdf = sort(rfonoff.Fixed3DError_m_);

    rfonoffstats.plotdata.TTFixeds = ttfixcdf;
    rfonoffstats.plotdata.Max2DFixedErr = max2derrcdf;
    rfonoffstats.plotdata.Max3DFixedErr = max3derrcdf;
    rfonoffstats.TTFixed = [ttfixcdf(sig1); ttfixcdf(sig2); ttfixcdf(sig3)];
    rfonoffstats.Max2DFixedStats = [max2derrcdf(sig1); max2derrcdf(sig2); max2derrcdf(sig3)];
    rfonoffstats.Max3DFixedStats = [max3derrcdf(sig1); max3derrcdf(sig2); max3derrcdf(sig3)];
    

toc