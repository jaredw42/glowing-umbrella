%% GTT Continous Navigation analysis and plotting script
% Jared Wilson
% Swift Navigation

%reads data from Continous Navigation testing from GTT stand and plots


close all
global figPos   
clearvars -except figPos %dut_foldernames dut_info

[dut_foldernames, dut_info] = gt_userinput();

nDevices = length(dut_foldernames)

outPath = dut_info{1};
outName = dut_info{2};
outCorrType = dut_info{3};

testType = 'CN'

%% load in rfonoff and nav csv files into tables


tic
for i = 1: length(dut_foldernames)
    
    GTT(i).filepath = dut_foldernames{i};

    if strcmp(GTT(i).filepath(end), '/') == false
        GTT(i).filepath = strcat(GTT(i).filepath, '/');
    end
    
    
    GTT(i).rxdata = getReceiverData(GTT(i).filepath);
    GTT(i).nav = readtable(strcat(GTT(i).filepath, 'nav.csv'));
    GTT(i).trk = readtable(strcat(GTT(i).filepath, 'trk.csv'));
    toc
end

 %% CDF calc function calls

for i = 1:length(GTT)

   [GTT(i).nav, GTT(i).navstats] = calc_cdf_nav(GTT(i).nav, GTT(i).rxdata.truthPos);
    GTT(i).fixstats = calc_fixstats(GTT(i).navstats);

end

%% title and legend info

ds = GTT(1).rxdata.dateStamp(3:end);
ds = strcat(ds, '_')

ts = strcat(outName,outCorrType, ds)
ts = strrep(ts, '_', ' ')


fp = strcat(outPath, ds, outName, outCorrType)

tStamp = ts;
tStr = {'GTT Continous Navigation ',  ['Dataset: ' tStamp], ' ' }





for i = 1:nDevices
    legNames{i} = strcat(GTT(i).rxdata.gtname, GTT(i).rxdata.FWRev);
    colname{i} = GTT(i).rxdata.gtname;
end

axDark = [ 0.4 0.4 0.4] %tuple for dark axis background alpha
tabColNames = colname
tabPosition = [850 100 500 150]
tabRowNames = {'One Sig', 'Two Sig', 'Three Sig', 'Count'}
tabFontSize = 14;
    
%% figure 1 SVs used


figure (1)
hold on
grid on
 set(gcf,'Position', figPos);


for i = 1:length(GTT)
    
    plot(GTT(i).nav.TOW_s_, GTT(i).nav.SVsUsed, 'LineWidth', 2)
    
   
end

legend(legNames)
xlabel('GPS TOW (s)')
ylabel('SVs Used');
tStr{end} = 'Satellites Used';
title(tStr)

pngFull = strcat(fp, 'Sats_used');
print(gcf, '-dpng', pngFull);
%% figure 2 diff mode

figure (2)



a = uitable;
a.RowName = {'% RTK Fixed', '% RTK Float', '% DGNSS', '%SPS', 'Total Fix %', '# of missing fixes'};
a.ColumnName = colname;
a.Data = gtpctfix;
a.Position = tabPosition;
a.FontSize = tabFontSize;


hold on
grid on
set(gcf,'Position', figPos);


for i = 1:length(GTT)
        plot(GTT(i).nav.TOW_s_, GTT(i).nav.FixMode, 'LineWidth', 2);
     
end

legend(legNames)
xlabel('GPS TOW (s)')
ylabel('Differential Mode');
%xlim([525000 604800])
tStr{end} = 'Differential Mode';
title(tStr)

pngFull = strcat(fp, 'dMode');
print(gcf, '-dpng', pngFull);

%% figure 3 overhead n vs e 



figure (3)

hold on
grid on
set(gcf,'Position', figPos);

 
 for i = 1:length(GTT)
       plot(GTT(i).nav.errE, GTT(i).nav.errN, 'LineWidth', 2);
 end

legend(legNames)
xlabel('E/W Error (m)')
ylabel('N/S Error (m)');

tStr{end} = 'Overhead Plot';
title(tStr)

pngFull = strcat(fp, 'n_vs_e');
print(gcf, '-dpng', pngFull);



%% figure 4 horiz error vs time

figure (4)

hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).nav.TOW_s_, GTT(i).nav.errHoriz)%, GTT(i).nav.TOW_s_, GTT(i).nav.EHPE_m_, '.')

end

ax = gca;
%ax.Color = [0.3 0.3 0.3];
axis tight
%ylim([0 0.1])

legend(legNames)
xlabel('GPS TOW (s)')
ylabel('Horizontal Error (m)');

tStr{end} = 'Horizontal Error vs Time';
title(tStr)

pngFull = strcat(fp, 'errHoriz_all');
print(gcf, '-dpng', pngFull);

%% figure 5 3d error vs time
figure(5)

hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).nav.TOW_s_, GTT(i).nav.err3D)

end

%ax = gca;
%ax.Color = [0.3 0.3 0.3];
%ylim([0 90])
axis tight
ylim([0 0.2])
legend(legNames)
xlabel('GPS TOW (s)')
ylabel('3D Error (m)');

tStr{end} = '3D Error (All Epochs)';
title(tStr)

pngFull = strcat(fp, 'err3d_all');
print(gcf, '-dpng', pngFull);



toc
