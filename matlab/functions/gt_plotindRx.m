%% gt_plotIndividualrx


tic
%% indvidual rx plots

if testType == 'CN'
    plothorizlimits = [0 2];
    plot3Dlimits = [0 3];
    plotNEDlimits = [-0.2 0.2];
    gtTitle = 'GTT Continuous Navigation'
    
elseif testType == 'ST'
    plothorizlimits = [0 10];
    plot3Dlimits = [0 20];
    plotNEDlimits = [-3 3];
    gtTitle = 'GTT Starts';
    
       
elseif testType == 'RF'
    plothorizlimits = [0 10];
    plot3Dlimits = [0 20];
    plotNEDlimits = [-3 3];
    gtTitle = 'GTT RF On/Off';
    
end


%% color code valid indicies by diff mode
close all
for i = 1:nDevices
    
    
    nav = GTT(i).nav;
    
    vi4 = nav.FixMode == 4;
    vi3 = nav.FixMode == 3;
    vi2 = nav.FixMode == 2;
    vi1 = nav.FixMode == 1;
    
    
    tStr = {gtTitle  ['Dataset: ' tStamp], ['Station: ' GTT(i).rxdata.gtname], ' ' }

    %% figure 1x  overhead by diff mode
    figure(i+10)
    set(gcf, 'Position', figPos)
    hold on
    grid on


       plot(nav.errE(vi1), nav.errN(vi1), 'r');
       plot(nav.errE(vi2), nav.errN(vi2), 'p');
       plot(nav.errE(vi3), nav.errN(vi3), 'b');
       plot(nav.errE(vi4), nav.errN(vi4), 'g');
    
       tStr{end} = 'North vs East Error by Differential Mode'
       title(tStr)
       
    
       ylabel('N/S Error')
       xlabel('E/W Error')
       if testType == 'CN'
           ylim(plotNEDlimits)
           xlim(plotNEDlimits)
       end
       
      pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'errN_vs_E_diffmode')
      print(gcf, '-dpng', pngFull); 
%% fig 2x horiz error by diff mode

    figure(i+20)
    set(gcf, 'Position', figPos)
    hold on
    grid on
    plot(nav.TOW_s_(vi4), nav.errHoriz(vi4), 'g.');
    plot(nav.TOW_s_(vi3), nav.errHoriz(vi3), 'b.');
    plot(nav.TOW_s_(vi2), nav.errHoriz(vi2), 'm.');
    plot(nav.TOW_s_(vi1), nav.errHoriz(vi1), 'r.');
    
    tStr{end} = 'Horizontal Error vs Time by Differential Mode';
    title(tStr)
    xlabel('GPS TOW (s)')
    ylabel('Horizontal Error (m)')
    
    if testType == 'CN'
        ylim(plothorizlimits)
    end
    
    legend('RTK Fixed', 'RTK Float', 'DGNSS', 'SPS')
    
    
    pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'errHoriz_diffmode')
    print(gcf, '-dpng', pngFull);   
    
    
    %% fig3x err3d by diff mode
    figure(i+30)
    set(gcf, 'Position', figPos)
    hold on
    grid on

    plot(nav.TOW_s_(vi4), nav.err3D(vi4), 'g.');
    plot(nav.TOW_s_(vi3), nav.err3D(vi3), 'b.');
    plot(nav.TOW_s_(vi2), nav.err3D(vi2), 'm.');
    plot(nav.TOW_s_(vi1), nav.err3D(vi1), 'r.');
    
    tStr{end} = '3D Error vs Time by Differential Mode';
    title(tStr)
    xlabel('GPS TOW (s)')
    ylabel('3D Error (m)')
    if testType == 'CN'
      ylim(plot3Dlimits)
    end
    legend('RTK Fixed', 'RTK Float', 'DGNSS', 'SPS')
    
    pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'err3d_diffmode')
    print(gcf, '-dpng', pngFull);
    
    %% fig 4x errNED
    figure(i+40)
    set(gcf, 'Position', figPos)
    hold on
    grid on
    
    plot(nav.TOW_s_, nav.errN, nav.TOW_s_, nav.errE, nav.TOW_s_, nav.errD)
    
    
    tStr{end} = 'Error North/East/Down vs Time';
    title(tStr)
    xlabel('GPS TOW (s)')
    ylabel('Error (m)')
    ylim(plotNEDlimits)
    legend('errN', 'errE', 'errD')
    
    pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'errNED')
    print(gcf, '-dpng', pngFull);

    %% figure 5x real and predicted horiz
    figure(i+50)
    
 
    set(gcf, 'Position', figPos)
    hold on
    grid on
    plot(nav.TOW_s_, nav.errHoriz);
    plot(nav.TOW_s_, nav.EHPE_m_)

    tStr{end} = 'Real and Predicted Horizontal Error vs Time';
    title(tStr)
    xlabel('GPS TOW (s)')
    ylabel('Horizontal Error (m)')
    ylim(plothorizlimits)
     
    legend('Real Horiz Error', 'HRMS Predicted Error')
    
    pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'errHoriz_HRMS')
    print(gcf, '-dpng', pngFull);
    
    
    %% fig6xs real and predicted 3d
    figure(i+60)
    
    set(gcf, 'Position', figPos)
    hold on
    grid on
    
    plot(nav.TOW_s_, nav.err3D);
    plot(nav.TOW_s_, nav.EVPE_m_);
    
    tStr{end} = 'Real and Predicted 3D Error vs Time';
    title(tStr)
    xlabel('GPS TOW (s)')
    ylabel('3D Error (m)')
    ylim(plot3Dlimits)
    legend('Real 3D Error', '3D RMS Predicted Error')
    
    pngFull = strcat(outPath, GTT(i).rxdata.gtname,'_', outCorrType, dStamp, 'err3D_VRMS')
    print(gcf, '-dpng', pngFull);
end
   
toc

%%

    




%         
% figure (8)
% 
% 
% hold on
% grid on
% set(gcf, 'Position', figPos)
% set(gcf, 'InvertHardcopy', 'off')
% for i = 1:length(GTT)
%     plot(GTT(i).nav.TOW_s_, GTT(i).nav.errN, '.', GTT(i).nav.TOW_s_, GTT(i).nav.errE,'.', GTT(i).nav.TOW_s_, GTT(i).nav.errD, '.')   
% end
% 
% 
% %ylim([-0.1 0.1])
% legend(legNames)
% xlabel('GPS TOW (s)')
% ylabel('Error (m)');
% ax = gca;
% ax.Color = [0.8 0.8 0.8];
% 
% tStr{end} = 'North/East/Down Error vs GPS Time';
% title(tStr)
% pngFull = strcat(outPath, outName, outCorrType, dStamp, 'NED_vs_time')
% %print(gcf, '-dpng', pngFull);



