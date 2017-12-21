%% GTT Starts Plotter
% Jared Wilson
% Swift Navigation

%reads data from RTK Starts testing from GTT stand then plots the data

ckClear = questdlg('Do you wish to clear the workspace and close all plots?');

if strcmp(ckClear, 'Yes') == true
    
    close all
    clearvars -except figPos 

    GTT = struct();
    ckClear2 = 'Yes';
elseif strcmp(ckClear, 'No') == true
    ckClear2 = questdlg('Do you wish to reinput DUT info?');
end

    
    if strcmp(ckClear2, 'Yes') == true
    %% user input folder info and load nav and rf on/off data
        x = (inputdlg('Enter number of devices'));
        nDevices = str2double(x{:});


        %% plot details
        set(0,'defaultAxesGridAlpha', 0.5)
        set(0,'defaultAxesFontSize', 16)

        nLines = nDevices ;
        prompt = {'Folder 1', 'Folder 2', 'Folder 3', 'Folder 4', 'Folder 5', 'Folder 6'};

        dlg_title = 'Test folder names (Leave blank if needed)'
        defaultans = {'', '', '', '', '', ''}
        options.Resize = 'on'
        dut_foldernames = inputdlg(prompt, dlg_title, [1,100], defaultans, options)

        if nDevices == 2;
            dut_foldernames(3:end, :) = []
        end

        %%

        prompt = {'Output Folder Directory', 'File name prefix', 'Correction Type',...
            'Date stamp', 'Outage Duration', 'Legend Names'};

        dlg_title = 'Input output plot file info';

        defaultans = {'/Users/jwilson/SwiftNav/Piksi_1_3_testing/plots/v139/',...
            'GTT_Starts_', 'SBL_' '1220A', '10s',...
            'GTT33 - v1.3.10, GTT12 - v1.2.14'} ;%, GTT13 - v1.3.7, GTT14v- v1.2.14, GTT21 - PR1517, GTT 22 - PR1518' };

        dut_info = inputdlg(prompt, dlg_title, [1, 100], defaultans, options);
        outPath = dut_info{1};
        outName = dut_info{2};
        outCorrType = dut_info{3};
        %corrType = 'RTK Short Baseline'
        dStamp = dut_info{4}
        rxOffTime = dut_info{5}


        legNames = strsplit(dut_info{6}, ',')

    end
    %% load in rfonoff and nav csv files into tables


    tic
    for i = 1: nDevices;

        GTT(i).filepath = dut_foldernames{i};

        if strcmp(GTT(i).filepath(end), '/') == false
            GTT(i).filepath = strcat(GTT(i).filepath, '/');
        end


        GTT(i).trk = readtable(strcat(GTT(i).filepath, 'trk.csv'));
        GTT(i).nav = readtable(strcat(GTT(i).filepath, 'nav.csv'));
        GTT(i).starts = readtable(strcat(GTT(i).filepath, 'starts.csv'));
        toc
    end
 %% CDF calc function calls

    for i = 1:length(GTT)
        GTT(i).navstats = calc_cdf_nav(GTT(i).nav);
        GTT(i).startstats = calc_cdf_rfonoff(GTT(i).starts);
    end



%% title info

tStr = {'GTT Power On/Off Test',  ['Power Off Duration:',rxOffTime],  ['Dataset: ' dStamp]}


%% figure 1 cdf ttsps



figure (1)
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
tStr{4} = 'Time to SPS Fixed';
title(tStr)

pngFull = strcat(outPath,outName, outCorrType, dStamp, 'TTSPS');
print(gcf, '-dpng', pngFull);
%% figure 2 ttfloat

figure (2)
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

tStr{4} = 'Time to RTK Float';
title(tStr)

pngFull = strcat(outPath,outName, outCorrType, dStamp, 'TTFloat');
print(gcf, '-dpng', pngFull);

%% figure 3 cdf ttfixed



figure (3)

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

tStr{4} = 'Time to RTK Fixed';
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

tStr{4} = 'Max Horiz Error by Cycle (RTK Fixed)';
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

tStr{4} = 'Max Horiz Error by Cycle (RTK Float)';
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

tStr{4} = 'CDF Max Horiz Error by Cycle (SPS)';
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

tStr{4} = 'CDF Max Horiz Error by Cycle (RTK Fixed)';
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

tStr{4} = 'CDF Max Horiz Error by Cycle (RTK Fixed) (xlimit = 0.05m)';
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

tStr{4} = 'CDF Max Horiz Error by Cycle (RTK Float)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'CDF_Max_RTKFloat');
print(gcf, '-dpng', pngFull);
toc
