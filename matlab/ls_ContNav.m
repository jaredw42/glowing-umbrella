%% Swift Navigation
% Labsat data analyzer

ckClear  = questdlg('Do you wish to clear all variables and close all plots?');
    
    if strcmp(ckClear, 'Yes') == true
        close all
        clearvars -except figPos
        
        refSource = questdlg('Enter Reference source type', 'Reference Source', 'NV Waypoint PP', 'Other', 'NV Waypoint PP');
    end
    
    
prompt = {'Playback directory name', 'Dataset Name', 'Legend Names'}
tDlg = 'Enter Playback Info';
defResp = {'/Volumes/data/data/PlaybackTesting/2017-12/18-d1_loop_139_5x/',...
            '1218D1', 'PM41 - v1.3.10, PM42 - v1.3.10, PM43 - v1.2.14, PM44 - v1.2.14'}
dut_info = inputdlg(prompt, tDlg,[1 100], defResp )

rtPath = dut_info{1};

if strcmp(rtPath(end), '/') == false
    rtPath = strcat(rtPath, '/')
end

dName = dut_info{2};

legNames = strsplit(dut_info{3})

set(groot,'defaultAxesGridAlpha', .75)
set(groot,'defaultAxesFontSize', 18)
 

 
 %% load ref data


refName = 'jw_1210_d1.txt'

x = strcat(rtPath, refName);

ref = readtable(x);
%%

dutExp = 'DUT'

x = dir(rtPath)
x(1:2) = [];
x(~[x.isdir]) = [];

for i = 1:length(x)
    plPath{i} = x(i).name
end
%%
tic
for i = 1:length(plPath)
    d = 1;
    runPath = strcat(rtPath, '/', plPath{i}, '/');
    x = dir(runPath);
    
    for j = 1: length(x)
        
      if isempty(regexp(x(j).name,dutExp)) == false
          
          dutName = strcat(runPath, x(j).name, '/nav.csv')
          DUT{d,i} = readtable(dutName);
          d = d + 1;

      end
    end

    
end
disp('playbacks loaded')
toc

%%



tic
refElips = referenceEllipsoid('grs80');
for r = 1:length(DUT)

    for d = 1:4

        clear pm
        clear errdata
        pm = DUT{d,r};

        [vi, vRef, vRx] = intersect(ref.GPSTime, pm.TOW_s_);

        [errdata.errN, errdata.errE, errdata.errD] = geodetic2ned(pm.Lat_deg_(vRx), pm.Lon_deg_(vRx), pm.AltEllips_m_(vRx),...
            ref.Latitude(vRef), ref.Longitude(vRef), ref.H_Ell(vRef), refElips);

        errdata.errHoriz = (errdata.errN.^2 + errdata.errE.^2).^0.5;
        errdata.err3D = (errdata.errN.^2 + errdata.errE.^2 + errdata.errD.^2).^0.5;

        errdata.time = pm.TOW_s_(vRx);
        errdata.fixmode = pm.FixMode(vRx);
        LS(d,r).errdata = errdata;
    
    end

end

%% 

for i = 1:4
    for j = 1:length(LS)
     LS(i,j).cdf = calc_cdf_drivecsv(LS(i,j).errdata)
    end
end


%% figure 1 all epochs
figure (1)
hold on
grid on
set(gcf,'Position', figPos)
    tStr = strcat(dName, sprintf('\nP0-P90 Horizontal error CDF for All Epochs'));
   % tStr = strcat(tStr, sprintf('\nOne Sigma [m] PM1 = %.2f PM2 = %.2f PM3 = %.2f',...

for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.all_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.all_horiz_plotdata))'/length(LS(i,j).cdf.all_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.all_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.all_horiz_plotdata))'/length(LS(i,j).cdf.all_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end
%ylim([0 90])
legend('FW v1.3.10', 'FW v 1.2.14')
title(tStr)

ylabel('% of Epochs')
xlabel('Horizontal Error (m)')

pngFull = strcat(fPath{1}, fName, 'CDF_horiz_all_P0')
%print(gcf, '-dpng', pngFull);
%%
figure (11)

hold on
grid on

set(gcf,'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

tStr = strcat(dName, sprintf('\nP90-P99 Horizontal error CDF for All Epochs'));

for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.all_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.all_horiz_plotdata))'/length(LS(i,j).cdf.all_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.all_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.all_horiz_plotdata))'/length(LS(i,j).cdf.all_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end


fig = gca;
fig.Color = [0.6 0.6 0.6];

ylim([90 99])
ylabel('% of Epochs')
xlabel('Horizontal Error (m)')

legend(legend_cells)
title(tStr);

pngFull = strcat(fPath{1}, fName, 'CDF_horiz_all_P90')
%print(gcf, '-dpng', pngFull);

%% figure 2 all RTK 

figure(2) 

hold on
grid on
set(gcf,'Position', figPos)

 tStr = strcat(dName, sprintf('\nP0-P90 Horizontal error CDF for RTK Combined Epochs'));

for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.ALL_RTK_horiz_plotdata))'/length(LS(i,j).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.ALL_RTK_horiz_plotdata))'/length(LS(i,j).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end

ylim([0 90])
%legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m) (RTK Combined)')
title(tStr)
%%
figure(22)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');
set(gcf,'Position', figPos)


 tStr = strcat(dName, sprintf('\nP90-P99 Horizontal error CDF for RTK Combined Epochs'));

for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.ALL_RTK_horiz_plotdata))'/length(LS(i,j).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.ALL_RTK_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.ALL_RTK_horiz_plotdata))'/length(LS(i,j).cdf.ALL_RTK_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end

fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
%legend(legend_cells)
ylabel('Percent of Epochs')

xlabel('Horizontal Error (m) (RTK Combined)')
title(tStr)

%%  figure 3 RTK Fixed


figure(3) 

hold on
grid on
set(gcf,'Position', figPos)


for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.RTKfixed_horiz_plotdata))'/length(LS(i,j).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.RTKfixed_horiz_plotdata))'/length(LS(i,j).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end

ylim([0 90])
%legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(33)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');
set(gcf,'Position', figPos)

for i = 1:4
    for j = 1 : length(LS)
        
        if i < 3
            plot(LS(i,j).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.RTKfixed_horiz_plotdata))'/length(LS(i,j).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2, 'Color', 'r')
        end
        
        if i > 2
            plot(LS(i,j).cdf.RTKfixed_horiz_plotdata, 100 * (1:length(LS(i,j).cdf.RTKfixed_horiz_plotdata))'/length(LS(i,j).cdf.RTKfixed_horiz_plotdata), 'LineWidth', 2, 'Color','b')
        end
    end
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
%legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

%% Figure 4 RTK floaaaaat


figure(4) 

hold on
grid on

for i = 1 : length(LS)
    plot(LS(i).cdf.RTKfloat_horiz_plotdata, 100 * (1:length(LS(i).cdf.RTKfloat_horiz_plotdata))'/length(LS(i).cdf.RTKfloat_horiz_plotdata), 'LineWidth', 2)
end

ylim([0 90])
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(44)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');

for i = 1 : length(LS)
    plot(LS(i).cdf.RTKfloat_horiz_plotdata, 100 * (1:length(LS(i).cdf.RTKfloat_horiz_plotdata))'/length(LS(i).cdf.RTKfloat_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

%% figure 5 dat code diff


figure(5) 

hold on
grid on

for i = 1 : length(LS)
    plot(LS(i).cdf.DGNSS_horiz_plotdata, 100 * (1:length(LS(i).cdf.DGNSS_horiz_plotdata))'/length(LS(i).cdf.DGNSS_horiz_plotdata), 'LineWidth', 2)
end

ylim([0 90])
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(55)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');

for i = 1 : length(LS)
    plot(LS(i).cdf.DGNSS_horiz_plotdata, 100 * (1:length(LS(i).cdf.DGNSS_horiz_plotdata))'/length(LS(i).cdf.DGNSS_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

%% fig 6 SPS
% because corrections are overrated


figure(6) 

hold on
grid on

for i = 1 : length(LS)
    plot(LS(i).cdf.SPS_horiz_plotdata, 100 * (1:length(LS(i).cdf.SPS_horiz_plotdata))'/length(LS(i).cdf.SPS_horiz_plotdata), 'LineWidth', 2)
end

ylim([0 90])
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')


figure(66)

hold on
grid on
set(gcf,'InvertHardCopy', 'off');

for i = 1 : length(LS)
    plot(LS(i).cdf.SPS_horiz_plotdata, 100 * (1:length(LS(i).cdf.SPS_horiz_plotdata))'/length(LS(i).cdf.SPS_horiz_plotdata), 'LineWidth', 2)
end
fig = gca;
fig.Color = [0.6 0.6 0.6];
ylim([90 99]);
legend(legend_cells)
ylabel('Percent of Epochs')
xlabel('Horizontal Error (m)')

