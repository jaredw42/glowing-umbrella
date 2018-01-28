

figure(21)

a = uitable

for i = 1:length(GTT)
    cdfdata(:,i) = [GTT(i).navstats.RTKfixed_err3D];
end
a.Data = cdfdata;
a.FontSize = tabFontSize;
a.RowName = tabRowNames;
a.ColumnName = tabColNames;
a.Position = tabPosition

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfixed_errHoriz,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfixed_err3D))'/length(GTT(i).navstats.plotdata.RTKfixed_err3D),...
        'LineWidth', 2)
    
    if i == 1
        hold on
        grid on
    end
    
end

ax = gca;
%ylim([0 90])

legend(legNames, 'Location', 'east')
xlabel('3D Error (m)')
ylabel('Percent of Epochs');

tStr{end} = 'P0-90 CDF Horizontal Error (RTK Fixed)';
title(tStr)

pngFull = strcat(outPath, outName, outCorrType, dStamp, 'cdf_3D_rtkfixedp0');

figure (22)

b = uitable
b.RowName = tabRowNames;
b.ColumnName = tabColNames;
b.Position = tabPosition
b.Data = cdfdata;
b.FontSize = tabFontSize;

set(gcf, 'Position', figPos)
set(gcf, 'InvertHardcopy', 'off')

for i = 1:length(GTT)
    plot(GTT(i).navstats.plotdata.RTKfixed_err3D,...
        100 * (1:length(GTT(i).navstats.plotdata.RTKfixed_err3D))'/length(GTT(i).navstats.plotdata.RTKfixed_err3D),...
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

tStr{end} = 'P90-100 CDF 3D Error (RTK Fixed)';
title(tStr)


pngFull = strcat(outPath, outName, outCorrType, dStamp, 'cdf_3D_rtkfixedp90');