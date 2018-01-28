 
ckClear  = questdlg('Do you wish to clear all variables and close all plots?');
    
    if strcmp(ckClear, 'Yes') == true
        close all
        clearvars -except figPos
        
        refSource = questdlg('Enter Reference source type', 'Reference Source', 'NV Waypoint PP', 'Other', 'NV Waypoint PP');
    end
    
            


set(groot,'defaultAxesGridAlpha', .75)
set(groot,'defaultAxesFontSize', 18)
 
%%  file info


prompt = {'Enter Drive test root path', 'Reference file', ...
            'Folder 1', 'Folder 2', 'Folder 3', 'Folder 4'};
        
tDlg = 'Drive Test Analysis 0.1'
defAns = {'/Users/jwilson/SwiftNav/Piksi_1_3_testing/drive/2017-12-19-drive1-sj-bailey-101-280-87-sj/',...
            'sw_1219_d1.txt', 'pm1/', 'pm2/', 'pm3/', ''};

options.Resize = 'on'
dut_foldernames = inputdlg(prompt, tDlg, [1, 100], defAns, options)

for i = 4:length(dut_foldernames)
    if isempty(dut_foldernames{i}) == true
        dut_foldernames(i) = []
    end
end

% fPath = inputdlg('Enter Drive test folder path')
% fName = '20171219_D1_'
 % dName = 'Drive Test: 20171219 D1'
 %legNames = {'PM1-v1.2.14', 'PM2-v1.3.9', 'PM3-v1.4DEV'};
 legNames = {'Novatel + IMU', 'PM4 - v1.3.9 HDG', 'PM5-v1.3.9 5Hz LUTZ'}
 
 %% load data

refPath = strcat(dut_foldernames{1}, dut_foldernames{2})
% 
 ref = readtable(refPath);
%%
csvexp = '\d.csv$'
r = 1
for i = 3:length(dut_foldernames)
    
    dutPath = strcat(dut_foldernames{1}, dut_foldernames{i})
    x = dir(dutPath)
    for j = 1:length(x)
        if isempty(regexp(x(j).name,csvexp)) == false
            dutName = strcat(dutPath, x(j).name)
            ROV(r).csvdata = readtable(dutName);
            r = r + 1;
            
            break
        end
    end
    
  
end



%%

 %legNames = strsplit(dut_info{3}, ',')

%%
tic
refElips = referenceEllipsoid('wgs84');
for i = 1:length(ROV)
    
    clear pm
    clear errdata
    rov = ROV(i).csvdata;
    
    [vi, vRef, vRx] = intersect(ref.GPSTime, rov.GPSTOW_s_);

    [errdata.errN, errdata.errE, errdata.errD] = geodetic2ned(rov.Lat_deg_(vRx), rov.Lon_deg_(vRx), rov.AltEllips_m_(vRx),...
        ref.Latitude(vRef), ref.Longitude(vRef), ref.H_Ell(vRef), refElips);
    
    errdata.errHoriz = (errdata.errN.^2 + errdata.errE.^2).^0.5;
    errdata.err3D = (errdata.errN.^2 + errdata.errE.^2 + errdata.errD.^2).^0.5;
    
    errdata.time = rov.GPSTOW_s_(vRx);
    errdata.fixmode = rov.PosMode(vRx);
    ROV(i).errdata = errdata;
toc    
end


%% 

for i = 1:length(ROV)
 ROV(i).cdf = calc_cdf_drivecsv(ROV(i).errdata)
end


%%
dStamp = '1219D2'
dTitle = {'Drive Test',   ['Dataset: ' dStamp]}

dTitle = 'Piksi v1.3 Drive Test'
%% figure 1 all epochs
figure (1)
hold on
grid on
clear tStr
set(gcf,'Position', figPos)
    tStr1 = strcat(dTitle, sprintf('\nP0-P90 Horizontal error CDF for All Epochs'));
   % tStr = strcat(tStr, sprintf('\nOne Sigma [m] PM1 = %.2f PM2 = %.2f PM3 = %.2f',...

for i = 1 : length(ROV)
    plot(ROV(i).cdf.all_horiz_plotdata, 100 * (1:length(ROV(i).cdf.all_horiz_plotdata))'/length(ROV(i).cdf.all_horiz_plotdata), 'LineWidth', 2)
end


for i = 1:length(ROV)
    cdfArr(:,i) = ROV(i).cdf.all_horiz;
end

ds.all_horiz = cdfArr; 


ylim([0 90])
legend(legNames)
title(tStr1)

ylabel('% of Epochs')
xlabel('Horizontal Error (m)')

pngFull = strcat(dut_foldernames{1},  outName, 'CDF_allepochsP0');
%print(gcf, '-dpng', pngFull);

figure (11)

hold on
grid on

set(gcf,'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

tStr2 = strcat(dTitle, sprintf('\nP90-P99 Horizontal error CDF for All Epochs'));


for i = 1: length(ROV)
    plot(ROV(i).cdf.all_horiz_plotdata, 100 * (1:length(ROV(i).cdf.all_horiz_plotdata))'/length(ROV(i).cdf.all_horiz_plotdata), 'LineWidth', 2)
end

fig = gca;
fig.Color = [0.6 0.6 0.6];

%ylim([90 99])
ylabel('% of Epochs')
xlabel('Horizontal Error (m)')

legend(legNames)
title(tStr2);

pngFull = strcat(dut_foldernames{1},  outName, 'CDF_allepochsP90');
%print(gcf, '-dpng', pngFull);

%% figure 2 all RTK 

figure(2) 

hold on
grid on
set(gcf,'Position', figPos)

 tStr1 = strcat(dTitle, sprintf('\nP0-P90 Horizontal error CDF for RTK Combined Epochs'));

for i = 1 : length(ROV)
    plot(ROV(i).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(ROV(i).cdf.ALL_RTK_horiz_plotdata))'/length(ROV(i).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2)
end

for i = 1:length(ROV)
    cdfArr(:,i) = ROV(i).cdf.ALL_RTK_fixed_horiz
end

ds.RTKcombined = cdfArr

ylim([0 90])
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m) (RTK Combined)')
title(tStr1)

%%

figure(22)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');
set(gcf,'Position', figPos)


 tStr2 = strcat(dTitle, sprintf('\nP90-P99 Horizontal error CDF for RTK Combined Epochs'));


for i = 1 : length(ROV)
    plot(ROV(i).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(ROV(i).cdf.ALL_RTK_horiz_plotdata))'/length(ROV(i).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2)
end

fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legNames)
ylabel('Percent of Epochs')

xlabel('Horizontal Error (m) (RTK Combined)')
title(tStr2)

%%  figure 3 RTK Fixed


figure(3) 

hold on
grid on
set(gcf,'Position', figPos)


 tStr = strcat(dTitle, sprintf('\nP0-P90 Horizontal error CDF for RTK Fixed Epochs'));

for i = 1 : length(ROV)
    plot(ROV(i).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(ROV(i).cdf.RTKfixed_horiz_plotdata))'/length(ROV(i).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2)
end

for i = 1:length(ROV)
    cdfArr(:,i) = ROV(i).cdf.RTKfixed_horiz
end

ds.RTKfixed = cdfArr

ylim([0 90])
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')
title(tStr)
%%
figure(33)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');
set(gcf,'Position', figPos)
tStr = strcat(dTitle, sprintf('\nP90-P99 Horizontal error CDF for RTK Fixed Epochs'));

for i = 1 : length(ROV)
    plot(ROV(i).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(ROV(i).cdf.RTKfixed_horiz_plotdata))'/length(ROV(i).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2)
end

fig = gca;
fig.Color = [0.6 0.6 0.6];
%ylim([90 100]);
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')
title(tStr)
%% Figure 4 RTK floaaaaat


figure(4) 

hold on
grid on
set(gcf,'Position', figPos)
tStr = strcat(dTitle, sprintf('\nP0-P90 Horizontal error CDF for RTK Float Epochs'));


for i = 1 : length(ROV)
    plot(ROV(i).cdf.RTKfloat_horiz_plotdata, 100 * (1:length(ROV(i).cdf.RTKfloat_horiz_plotdata))'/length(ROV(i).cdf.RTKfloat_horiz_plotdata), 'LineWidth', 2)
end

ylim([0 90])
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')
title(tStr) 

for i = 1:length(ROV)
    cdfArr(:,i) = ROV(i).cdf.RTKfloat_horiz
end

ds.RTKfloat = cdfArr
%%
figure(44)

hold on
grid on

set(gcf,'Position', figPos)
set(gcf,'InvertHardCopy', 'off');

tStr = strcat(dTitle, sprintf('\nP0-P90 Horizontal error CDF for RTK Float Epochs'));

for i = 1 : length(ROV)
    plot(ROV(i).cdf.RTKfloat_horiz_plotdata, 100 * (1:length(ROV(i).cdf.RTKfloat_horiz_plotdata))'/length(ROV(i).cdf.RTKfloat_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')
title(tStr)

%% figure 5 dat code diff


figure(5) 

hold on
grid on

for i = 1 : length(ROV)
    plot(ROV(i).cdf.DGNSS_horiz_plotdata, 100 * (1:length(ROV(i).cdf.DGNSS_horiz_plotdata))'/length(ROV(i).cdf.DGNSS_horiz_plotdata), 'LineWidth', 2)
end

ylim([0 90])
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(55)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');

for i = 1 : length(ROV)
    plot(ROV(i).cdf.DGNSS_horiz_plotdata, 100 * (1:length(ROV(i).cdf.DGNSS_horiz_plotdata))'/length(ROV(i).cdf.DGNSS_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

%% fig 6 SPS
% because corrections are overrated


figure(6) 

hold on
grid on

for i = 1 : length(ROV)
    plot(ROV(i).cdf.SPS_horiz_plotdata, 100 * (1:length(ROV(i).cdf.SPS_horiz_plotdata))'/length(ROV(i).cdf.SPS_horiz_plotdata), 'LineWidth', 2)
end

for i = 2:length(ROV)
    cdfArr(:,i) = ROV(i).cdf.SPS_horiz
end

ds.SPShoriz = cdfArr

ylim([0 90])
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(66)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');

for i = 1 : length(ROV)
    plot(ROV(i).cdf.SPS_horiz_plotdata, 100 * (1:length(ROV(i).cdf.SPS_horiz_plotdata))'/length(ROV(i).cdf.SPS_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legNames)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

