function [fixstats] = calc_fixstats(navstats)
%finds count of bad RTK fixes within a range of values
%   currently finds 3D fixes worse than 0.25, 0.5 and 1 meter of error


errHoriz = navstats.plotdata.RTKfixed_errHoriz;
err3D = navstats.plotdata.RTKfixed_err3D;

totEpochs = length(err3D);

ff25 = totEpochs - find(err3D > 0.25, 1);
ff50 = totEpochs - find(err3D > 0.5, 1);
ff1m = totEpochs - find(err3D > 1, 1);

fixstats.falseCounts = [ff25; ff50; ff1m; NaN; totEpochs];
fixstats.badPct = [(ff25/totEpochs); ff50/totEpochs; ff1m/totEpochs] * 100;
fixstats.goodPct = 100 - fixstats.badPct;



%% calc fix percentages

n = navstats.count;
nepochs = n.allEpochs;

fixstats.pctrfixed = n.RTKfixed / nepochs * 100;
fixstats.pctrfloat = n.RTKfloat / nepochs* 100;
fixstats.pctdgps = n.DGNSS / nepochs * 100;
fixstats.pctsps = n.SPS / nepochs * 100; 

nfixes = n.RTKfixed + n.RTKfloat + n.DGNSS + n.SPS;

fixstats.pctfix = nfixes / nepochs * 100;
fixstats.missfix = nepochs - nfixes; 



end

