% for i = 1:length(y)
%     if isvarname(y{i}) == false
%         %y{i} = strcat('s',y{i})
%         y{i} = erase(y{i}, '-')
%     end
%    % y{i} = strrep(y{i}, '-', '_')
% end
% 
% drvtrk.Properties.VariableNames = y
% 


% %%
% cla
% hold on
% plot(drvtrk.GPS_TOW_s, drvtrk.Trk_SVs_L1, '.')
% plot(drvtrk.GPS_TOW_s, drvtrk.Trk_SVs_L2, '.')
% xlim([350655 350695])
% %ylim([2 12])
% %%
% clear a
% for i = 1:nDevices
%     a(:,i) = GTT(i).fixstats.badPct
% end


%% 



fp = '//Users/jwilson/SwiftNav/Piksi_1_4_testing/home/'

fn = 'swift-gnss-20180118-193336.sbp.json'

sbpid = strcat(fp, fn)
a = fopen(sbpid);

data = textscan(a)

