%% GTT Starts Plotter
% Jared Wilson
% Swift Navigation

%% reads data from RTK Starts testing from GTT stand then plots the data


close all
global figPos   


[dut_foldernames, dut_info] = gt_userinput

nDevices = length(dut_foldernames)

outPath = dut_info{1};
outName = dut_info{2};
outCorrType = dut_info{3};
dStamp = dut_info{4};
rxOffTime = dut_info{5};
testType = 'ST'

    %% load in rfonoff and nav csv files into tables


    tic
    for i = 1: nDevices

        GTT(i).filepath = dut_foldernames{i};

        if strcmp(GTT(i).filepath(end), '/') == false
            GTT(i).filepath = strcat(GTT(i).filepath, '/');
        end

        GTT(i).rxdata = getReceiverData(GTT(i).filepath);
        GTT(i).trk = readtable(strcat(GTT(i).filepath, 'trk.csv'));
        GTT(i).nav = readtable(strcat(GTT(i).filepath, 'nav.csv'));
        GTT(i).starts = readtable(strcat(GTT(i).filepath, 'starts.csv'));
        toc
    end
    
 %% CDF calc function calls

    for i = 1:length(GTT)
        
        [GTT(i).nav, GTT(i).navstats] = calc_cdf_nav(GTT(i).nav, GTT(i).rxdata.truthPos);
        GTT(i).startstats = calc_cdf_rfonoff(GTT(i).starts, testType);
        GTT(i).fixstats = calc_fixstats(GTT(i).navstats);
    end


%%
for i = 1:nDevices
    fs = GTT(i).fixstats;
    gtpctfix(1,i) = fs.pctrfixed;
    gtpctfix(2,i) = fs.pctrfloat;
    gtpctfix(3,i) = fs.pctdgps;
    gtpctfix(4,i) = fs.pctsps;
    gtpctfix(5,i) = fs.pctfix;
    gtpctfix(6,i) = fs.missfix;
end
%% title info

for i = 1:nDevices
    legNames{i} = strcat(GTT(i).rxdata.gtname, GTT(i).rxdata.FWRev);
    colname{i} = GTT(i).rxdata.gtname;
end

ts = strcat(outName,outCorrType, dStamp)
ts = strrep(ts, '_', ' ')
rxoff = strrep(rxOffTime, '_', ' ')
tStamp = ts;
tStr = {'GTT Power On/Off Test',  ['Power Off Duration:',rxoff],  ['Dataset: ' tStamp], ' ' }

axDark = [ 0.4 0.4 0.4] %tuple for dark axis background alpha
tabColNames = colname
tabPosition = [850 100 250 100]
tabRowNames = {'One Sig', 'Two Sig', 'Three Sig'}%, 'Count'}
tabFontSize = 14;
%% figure 1 cdf ttsps

figure (1)


for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).startstats.TTSPS]    ;
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
    plot(GTT(i).startstats.plotdata.TTSPSs,...
        100 * (1:length(GTT(i).startstats.plotdata.TTSPSs))'/length(GTT(i).startstats.plotdata.TTSPSs),...
        'LineWidth', 2)
end

legend(legNames)
xlabel('Time to SPS (s)')
ylabel('Percent of Cycles');
tStr{end} = 'Time to SPS Fixed';
title(tStr)

pngFull = strcat(outPath,outName, outCorrType, dStamp, 'TTSPS');
print(gcf, '-dpng', pngFull);
%% figure 2 ttfloat

figure (2)


for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).startstats.TTFloat]    ;
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
        plot(GTT(i).startstats.plotdata.TTFloats,...
        100 * (1:length(GTT(i).startstats.plotdata.TTFloats))'/length(GTT(i).startstats.plotdata.TTFloats),...
        'LineWidth', 2)
end

legend(legNames)
xlabel('Time to RTK Float (s)')
ylabel('Percent of Cycles');

tStr{end} = 'Time to RTK Float';
title(tStr)

pngFull = strcat(outPath,outName, outCorrType, dStamp, 'TTFloat');
print(gcf, '-dpng', pngFull);

%% figure 3 cdf ttfixed



figure (3)


for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).startstats.TTFixed]    ;
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
        plot(GTT(i).startstats.plotdata.TTFixeds,...
        100 * (1:length(GTT(i).startstats.plotdata.TTFixeds))'/length(GTT(i).startstats.plotdata.TTFixeds),...
        'LineWidth', 2)
 end

legend(legNames)
xlabel('Time to RTK Fixed (s)')
ylabel('Percent of Cycles');

tStr{end} = 'Time to RTK Fixed';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'TTFixed');
print(gcf, '-dpng', pngFull);



%% figure 4 max rtk fix by cycle

figure (4)

hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).starts.Fixed2DError_m_)
end

ax = gca;
ax.Color = [0.3 0.3 0.3];
ylim([0 0.5])

legend(legNames)
xlabel('Cycle Number')
ylabel('Max Horiz Error- RTK Fixed');

tStr{end} = 'Max Horiz Error by Cycle (RTK Fixed)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'Max_RTKFixed');
print(gcf, '-dpng', pngFull);

%% figure 5 max rtkfloat by cycle
figure(5)
hold on
grid on

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).starts.Float2DError_m_)
end

ax = gca;
ax.Color = [0.3 0.3 0.3];
ylim([0 20])

legend(legNames)
xlabel('Cycle Number')
ylabel('Max Horiz Error');

tStr{end} = 'Max Horiz Error by Cycle (RTK Float)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'Max_RTKFloat');
print(gcf, '-dpng', pngFull);




%% figure 6 cdf max sps

figure (6)


hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    plot(GTT(i).startstats.plotdata.Max2DSPSErr,...
        100 * (1:length(GTT(i).startstats.plotdata.Max2DSPSErr))'/length(GTT(i).startstats.plotdata.Max2DSPSErr),...
        'LineWidth', 2)
end

legend(legNames)
xlabel('Cycle Number')
ylabel('Max Horiz Error');

xlim([0 20])

tStr{end} = 'CDF Max Horiz Error by Cycle (SPS)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'CDF_Max_SPS');
print(gcf, '-dpng', pngFull);

%% figure 7 cdf max rtk Fixed 


figure (7)


hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    plot(GTT(i).startstats.plotdata.Max2DFixedErr,...
        100 * (1:length(GTT(i).startstats.plotdata.Max2DFixedErr))'/length(GTT(i).startstats.plotdata.Max2DFixedErr),...
        'LineWidth', 2)
end

%xlim([0 1.5])
legend(legNames)
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Fixed)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'CDF_Max_RTKFixed')
print(gcf, '-dpng', pngFull);

%% figure 8 cdf max rtk fixed zoomed
figure (8)


hold on
grid on
set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')
for i = 1:length(GTT)
    plot(GTT(i).startstats.plotdata.Max2DFixedErr,...
        100 * (1:length(GTT(i).startstats.plotdata.Max2DFixedErr))'/length(GTT(i).startstats.plotdata.Max2DFixedErr),...
        'LineWidth', 2)
end


xlim([0 .05])
legend(legNames)
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');
ax = gca;
ax.Color = [0.5 0.5 0.5];

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Fixed) (xlimit = 0.05m)';
title(tStr)
pngFull = strcat(outPath, outName, outCorrType, dStamp, 'CDF_Max_RTKFixed_zm');
print(gcf, '-dpng', pngFull);


%% figure 9 cdf max rtk float 

figure (9)


hold on
grid on
set(gcf, 'Position', figPos)

for i = 1:length(GTT)
    plot(GTT(i).startstats.plotdata.Max2DFloatErr,...
        100 * (1:length(GTT(i).startstats.plotdata.Max2DFloatErr))'/length(GTT(i).startstats.plotdata.Max2DFloatErr),...
        'LineWidth', 2)
end


xlim([0 10])
legend(legNames)
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'CDF Max Horiz Error by Cycle (RTK Float)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'CDF_Max_RTKFloat');
print(gcf, '-dpng', pngFull);
%%

figure (99)


for i = 1:length(GTT)
    ttfix(:,i) = [GTT(i).startstats.TTBoot]    ;
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
    plot(GTT(i).startstats.plotdata.TTBoot,...
        100 * (1:length(GTT(i).startstats.plotdata.TTBoot))'/length(GTT(i).startstats.plotdata.TTBoot),...
        'LineWidth', 2)
end

legend(legNames)
xlabel('Time to Boot (s)')
ylabel('Percent of Cycles');
tStr{end} = 'Time to Boot (s)';
title(tStr)

pngFull = strcat(outPath,outName, outCorrType, dStamp, 'TTBoot');
print(gcf, '-dpng', pngFull);
toc
