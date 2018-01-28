%% GTT RF On/Off Plotter
% Jared Wilson
% Swift Navigation

%reads data from RF On/Off testing from GTT stand and plots
%

close all
global figPos   
    
[dut_foldernames, dut_info] = gt_userinput

    
clearvars -except figPos dut_foldernames dut_info
nDevices = length(dut_foldernames)

outPath = dut_info{1}
outName = dut_info{2}
outCorrType = dut_info{3}
%dStamp = dut_info{4}
rfOffTime = dut_info{4}
testType = 'CR'

%% load in onoff and nav csv files into tables

tic

GTT = struct();

for i = 1: nDevices
    
    GTT(i).filepath = dut_foldernames{i};

    if strcmp(GTT(i).filepath(end), '/') == false
        GTT(i).filepath = strcat(GTT(i).filepath, '/');
    end
    
    GTT(i).rxdata = getReceiverData(GTT(i).filepath);
    GTT(i).trk = readtable(strcat(GTT(i).filepath, 'trk.csv'));
    GTT(i).nav = readtable(strcat(GTT(i).filepath, 'nav.csv'));
    GTT(i).onoff = readtable(strcat(GTT(i).filepath, 'corr-on-off.csv'));
    toc
end

 %% CDF calc function calls

for i = 1:length(GTT)
   [GTT(i).nav, GTT(i).navstats] = calc_cdf_nav(GTT(i).nav, GTT(i).rxdata.truthPos);
    GTT(i).onoffstats = calc_cdf_rfonoff(GTT(i).onoff);
    GTT(i).fixstats = calc_fixstats(GTT(i).navstats);
end

%% title and plot info
ds = GTT(1).rxdata.dateStamp(3:end);

ts = strcat(outName,outCorrType, ds)
ts = strrep(ts, '_', ' ')
rfoff = strrep(rfOffTime, '_', ' ')
tStamp = ts;
tStr = {'GTT Corrections On/Off Test',  ['Off Duration:',rfoff],  ['Dataset: ' tStamp], ' '}


ds = strcat(ds, '_')
fp = strcat(outPath, ds, outName, outCorrType)

for i = 1:nDevices
    legNames{i} = strcat(GTT(i).rxdata.gtname, GTT(i).rxdata.FWRev);
    colname{i} = GTT(i).rxdata.gtname;
end

axDark = [ 0.4 0.4 0.4] %tuple for dark axis background alpha
tabColNames = colname;
tabRowNames = {'One Sig', 'Two Sig', 'Three Sig', 'Count'};
tabFontSize = 14;
if nDevices == 4
    tabPosition = [850 100 425 115];
elseif nDevices < 3
    tabPosition = [850 100 250 115];
end


for i = 1:nDevices
   fs = GTT(i).fixstats;
    gtpctfix(1,i) = fs.pctrfixed;
    gtpctfix(2,i) = fs.pctrfloat;
    gtpctfix(3,i) = fs.pctdgps;
    gtpctfix(4,i) = fs.pctsps;
    gtpctfix(5,i) = fs.pctfix;
    gtpctfix(6,i) = fs.missfix;
end

%% figure 1 cdf ttsps
figure (1)


for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).onoffstats.TTSPS]    ;
end
a = uitable;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = ttfix;
a.FontSize = tabFontSize;

hold on
grid on
 set(gcf,'Position', figPos);


for i = 1:length(GTT)
    plot(GTT(i).onoffstats.plotdata.TTSPSs,...
        100 * (1:length(GTT(i).onoffstats.plotdata.TTSPSs))'/length(GTT(i).onoffstats.plotdata.TTSPSs),...
        'LineWidth', 2)
end

legend(legNames, 'Location', 'east')
xlabel('Time to SPS (s)')
ylabel('Percent of Cycles');
tStr{end} = 'Time to SPS Fixed';
title(tStr)

pngFull = strcat(fp, 'TTSPS')
print(gcf, '-dpng', pngFull);
%% figure 2 ttfloat
figure (2)

for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).onoffstats.TTFloat]    ;
end

a = uitable;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = ttfix;
a.FontSize = tabFontSize;

hold on
grid on
set(gcf,'Position', figPos);

for i = 1:length(GTT)
        plot(GTT(i).onoffstats.plotdata.TTFloats,...
        100 * (1:length(GTT(i).onoffstats.plotdata.TTFloats))'/length(GTT(i).onoffstats.plotdata.TTFloats),...
        'LineWidth', 2)
end

legend(legNames, 'Location', 'east')
xlabel('Time to RTK Float (s)')
ylabel('Percent of Cycles');

tStr{end} = 'Time to RTK Float';
title(tStr)

pngFull = strcat(fp, 'TTFloat');
print(gcf, '-dpng', pngFull);

%% figure 3 cdf ttfixed
figure (3)

for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).onoffstats.TTFixed]    ;
end

a = uitable;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = ttfix;
a.FontSize = tabFontSize;

hold on
grid on
 set(gcf,'Position', figPos);
 
 for i = 1:length(GTT)
        plot(GTT(i).onoffstats.plotdata.TTFixeds,...
        100 * (1:length(GTT(i).onoffstats.plotdata.TTFixeds))'/length(GTT(i).onoffstats.plotdata.TTFixeds),...
        'LineWidth', 2)
 end

legend(legNames, 'Location', 'east')
xlabel('Time to RTK Fixed (s)')
ylabel('Percent of Cycles');

tStr{end} = 'Time to RTK Fixed';
title(tStr)

pngFull = strcat(fp, 'TTFixed');
print(gcf, '-dpng', pngFull);

%% figure 4 max rtk fix by cycle
figure (4)

hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).onoff.Fixed2DError_m_)
end

ax = gca;
ax.Color = [0.3 0.3 0.3];
ylim([0 0.5])

legend(legNames, 'Location', 'east')
xlabel('Cycle Number')
ylabel('Max Horiz Error- RTK Fixed');

tStr{end} = 'Max Horiz Error by Cycle (RTK Fixed)';
title(tStr)

pngFull = strcat(fp, 'Max_RTKFixed');
print(gcf, '-dpng', pngFull);

%% figure 5 max rtkfloat by cycle
figure(5)
hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).onoff.Float2DError_m_)
end

ax = gca;
ax.Color = [0.3 0.3 0.3];
ylim([0 20])

legend(legNames, 'Location', 'east')
xlabel('Cycle Number')
ylabel('Max Horiz Error');

tStr{end} = 'Max Horiz Error by Cycle (RTK Float)';
title(tStr)

pngFull = strcat(fp, 'Max_RTKFloat');
print(gcf, '-dpng', pngFull);

%% figure 6 cdf max sps
figure (6)

hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
%     plot(GTT(i).onoffstats.plotdata.Max2DSPSErr,...
%         100 * (1:length(GTT(i).onoffstats.plotdata.Max2DSPSErr))'/length(GTT(i).onoffstats.plotdata.Max2DSPSErr),...
%         'LineWidth', 2)
    
    plot(GTT(i).onoff.SPS2DError_m_)
end

legend(legNames, 'Location', 'east')
xlabel('Cycle Number')
ylabel('Max Horiz Error');

%xlim([0 20])

tStr{end} = 'CDF Max Horiz Error by Cycle (SPS)';
title(tStr)

pngFull = strcat(fp, 'CDF_Max_SPS');
%print(gcf, '-dpng', pngFull);

%% figure 7 cdf max rtk Fixed 
figure (7)

hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    plot(GTT(i).onoffstats.plotdata.Max2DFixedErr,...
        100 * (1:length(GTT(i).onoffstats.plotdata.Max2DFixedErr))'/length(GTT(i).onoffstats.plotdata.Max2DFixedErr),...
        'LineWidth', 2)
end

xlim([0 0.2])
legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Fixed)';
title(tStr)

pngFull = strcat(fp, 'CDF_Max_RTKFixed');
print(gcf, '-dpng', pngFull);

%% figure 8 cdf max rtk fixed zoomed
figure (8)

hold on
grid on
set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).onoffstats.plotdata.Max2DFixedErr,...
        100 * (1:length(GTT(i).onoffstats.plotdata.Max2DFixedErr))'/length(GTT(i).onoffstats.plotdata.Max2DFixedErr),...
        'LineWidth', 2)
end


xlim([0 .05])
legend(legNames, 'Location', 'southeast')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');
ax = gca;
ax.Color = [0.5 0.5 0.5];

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Fixed) (xlimit = 0.05m)';
title(tStr)
pngFull = strcat(fp, 'CDF_Max_RTKFixed_zm')
print(gcf, '-dpng', pngFull);


%% figure 9 cdf max rtk float 
figure (9)

hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    plot(GTT(i).onoffstats.plotdata.Max2DFloatErr,...
        100 * (1:length(GTT(i).onoffstats.plotdata.Max2DFloatErr))'/length(GTT(i).onoffstats.plotdata.Max2DFloatErr),...
        'LineWidth', 2)
end


xlim([0 10])
legend(legNames, 'Location', 'southeast')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Float)';
title(tStr)

pngFull = strcat(fp, 'CDF_Max_RTKFloat');
print(gcf, '-dpng', pngFull);

%% figure 10 ttfloat vs rfofftime
figure (10)

hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    scatter(GTT(i).onoff.RFOffTime_s_, GTT(i).onoff.TTFloat_s_)
end
xlabel('RF Off Time (s)')
ylabel('Time to RTK Float (s)')
tStr{end} = 'Time to RTK Float vs RF Off Time'

title(tStr)
legend(legNames)

pngFull = strcat(fp, 'TTFloat_vs_RFoff');
print(gcf, '-dpng', pngFull);

%% figure 11 ttfixed vs rfofftime
figure (11)

hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    scatter(GTT(i).onoff.RFOffTime_s_, GTT(i).onoff.TTFixed_s_)
    
end
xlabel('RF Off Time (s)')
ylabel('Time to RTK Fixed (s)')
tStr{end} = 'Time to RTK Fixed vs RF Off Time';

ylim([5 30])
title(tStr)
legend(legNames)


pngFull = strcat(fp, 'TTFixed_vs_RFoff');
print(gcf, '-dpng', pngFull);

toc
