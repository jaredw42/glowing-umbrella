%% Plot GTT ContNav CDF (all devices)
disp('Plotting CDF (all devices')
tic

close all

for i = 1:length(GTT)
    
   colname{i} = GTT(i).rxdata.gtname;
    
end

for i = 1:length(GTT)
    
    cdfdata(:,i) = [GTT(i).navstats.allEpochs_err3D];

end
%%
axDark = [ 0.4 0.4 0.4] %tuple for dark axis background alpha
tabColNames = colname;
tabRowNames = {'One Sig', 'Two Sig', 'Three Sig', 'Count'};
tabFontSize = 14;
if nDevices == 4
    tabPosition = [850 100 425 115];
elseif nDevices < 3
    tabPosition = [850 100 250 115];
end


%% figure 11 & 12
figure(11)

a = uitable;
a.RowName = tabRowNames;
a.ColumnName = colname;
a.Data = cdfdata;
a.Position = tabPosition;
a.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.allEpochs_err3D,...
        100 * (1:length(GTT(i).navstats.plotdata.allEpochs_err3D))'/length(GTT(i).navstats.plotdata.allEpochs_err3D),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

%ax = gca;

ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('3D Error')
ylabel('Percent of Epochs');

tStr{end} = 'CDF 3D Error (All Epochs)';
title(tStr)

pngFull = strcat(fp, 'cdf_3d_allP0');
print(gcf, '-dpng', pngFull);



figure (12)

b = uitable;
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition;
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.allEpochs_err3D,...
        100 * (1:length(GTT(i).navstats.plotdata.allEpochs_err3D))'/length(GTT(i).navstats.plotdata.allEpochs_err3D),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

ax = gca;
ax.Color = axDark;
ylim([90 100])

legend(legNames, 'Location', 'east')
xlabel('3D Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'CDF 3D Error (All Epochs)';
title(tStr)

pngFull = strcat(fp, 'cdf_3d_allP90');
print(gcf, '-dpng', pngFull);


%% figure 13 & 14 cdf all epochs horiz

figure(13)

for i = 1:length(GTT)
    cdfdata(:,i) = [GTT(i).navstats.allEpochs_errHoriz]    ;
end
a = uitable;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = cdfdata;
a.FontSize = tabFontSize;


set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.allEpochs_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.allEpochs_errHoriz))'/length(GTT(i).navstats.plotdata.allEpochs_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

% ax = gca;
% ax.Color = axDark;
ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-P90 CDF Horizontal Error (All Epochs)';
title(tStr)

pngFull = strcat(fp, 'cdf_horiz_allP0');
print(gcf, '-dpng', pngFull);



figure (14)

b = uitable;
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition;
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.allEpochs_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.allEpochs_errHoriz))'/length(GTT(i).navstats.plotdata.allEpochs_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

ax = gca;
ax.Color = axDark;
ylim([90 100])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P90-100 CDF Horizontal Error (All Epochs)';
title(tStr)

pngFull = strcat(fp, 'cdf_horiz_allP90');
print(gcf, '-dpng', pngFull);
%% figure 15 & 16 cdf horiz rtk fixed


figure(15)

a = uitable;

for i = 1:length(GTT)
    cdfdata(:,i) = [GTT(i).navstats.RTKfixed_errHoriz];
end
a.Data = cdfdata;
a.FontSize = tabFontSize;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfixed_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfixed_errHoriz))'/length(GTT(i).navstats.plotdata.RTKfixed_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

%ax = gca;
ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-90 CDF Horizontal Error (RTK Fixed)';
title(tStr)

pngFull = strcat(fp, 'cdf_horiz_rtkfixedp0');
print(gcf, '-dpng', pngFull);



figure (16)

b = uitable;
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition;
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfixed_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfixed_errHoriz))'/length(GTT(i).navstats.plotdata.RTKfixed_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

ax = gca;
%ax.Color = axDark;
%ylim([90 100])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-100 CDF Horizontal Error (RTK Fixed)';
title(tStr)


pngFull = strcat(fp, 'cdf_horiz_rtkfixedp90');
%print(gcf, '-dpng', pngFull);
%% figure 17 & 18 cdf horiz rtk float


if any(gtpctfix(2,:) ~=0) == true

figure(17)

a = uitable;

for i = 1:length(GTT)
    cdfdata(:,i) = [GTT(i).navstats.RTKfloat_errHoriz];
end

a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = cdfdata;
a.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')


for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfloat_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfloat_errHoriz))'/length(GTT(i).navstats.plotdata.RTKfloat_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

%ax = gca;
ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-90 CDF Horizontal Error (RTK Float)';
title(tStr)

pngFull = strcat(fp, 'cdf_horiz_rtkfloatP0');
print(gcf, '-dpng', pngFull);



figure (18)

b = uitable;
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition;
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfloat_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfloat_errHoriz))'/length(GTT(i).navstats.plotdata.RTKfloat_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end


ax = gca;
ax.Color = axDark;
ylim([90 100])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P90-100CDF Horizontal Error (RTK Float)';
title(tStr)


pngFull = strcat(fp, 'cdf_horiz_rtkfloatP90');
print(gcf, '-dpng', pngFull);

end

%% figure 19 & 20 cdf horiz SPS

if any(gtpctfix(4,:) ~=0) == true

figure(19) %  p0 horiz sps

a = uitable;

for i = 1:length(GTT)
    cdfdata(:,i) = [GTT(i).navstats.SPS_errHoriz];
end

a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition;
a.Data = cdfdata;
a.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')


for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.SPS_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.SPS_errHoriz))'/length(GTT(i).navstats.plotdata.SPS_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

%ax = gca;
%ax.Color = axDark;
ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-P90 CDF Horizontal Error (SPS/Standalone)';
title(tStr)

pngFull = strcat(fp, 'cdf_horiz_spsP0');
print(gcf, '-dpng', pngFull);




figure (20) %p90 sps

b = uitable;
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition;
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.SPS_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.SPS_errHoriz))'/length(GTT(i).navstats.plotdata.SPS_errHoriz),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end


ax = gca;
ax.Color = axDark;
ylim([90 100])

legend(legNames, 'Location', 'east')
xlabel('Horizontal Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P90-100CDF Horizontal Error (SPS/Standalone)';
title(tStr)


pngFull = strcat(fp, 'cdf_horiz_spsP90');
print(gcf, '-dpng', pngFull);

end

toc