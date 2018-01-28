function [dut_foldernames, dut_info] = gt_userinput()
%GT_USERINPUT Summary of this function goes here
%   Detailed explanation goes here

%% user input folder info and load nav and rf on/off data



%% plot details
set(0,'defaultAxesGridAlpha', 0.5)
set(0,'defaultAxesFontSize', 16)

prompt = {'Folder 1', 'Folder 2', 'Folder 3', 'Folder 4', 'Folder 5', 'Folder 6'};
        
dlg_title = 'Test folder names (Leave blank if needed)'
defaultans = {'', '', '', '', '', ''}
options.Resize = 'on'
dut_foldernames = inputdlg(prompt, dlg_title, [1,100], defaultans, options)

for i = 1:length(dut_foldernames)
    if isempty(dut_foldernames{i}) == true
        dut_foldernames = dut_foldernames(1:(i-1));
        break
    end
end


%%

prompt = {'Output Folder Directory', 'File name prefix', 'Correction Type',...
           'Outage Cycle Duration'}

dlg_title = 'Input plot info'

defaultans = {'/Users/jwilson/SwiftNav/dev/plots/',...
               'GT3CN_', 'RTCM3S_', '15-35 s'};
 
dut_info = inputdlg(prompt, dlg_title, [1, 100], defaultans)

%% save file paths to text file

gtruns = fopen('/Users/jwilson/SwiftNav/glowing-umbrella/matlab/ref/gtt_runs.txt', 'a')

for i = 1: length(dut_foldernames)
    fprintf(gtruns, '%s \n', dut_foldernames{i})
end
fclose(gtruns)






