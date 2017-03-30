function res = xcorrmod(d1, d2, trials, range)
%% Summary
% low-level function to do cross correlations for categorical data
% d1 is an Nx1 array of category values
% d2 is an Nx1 array of category values
% trials is an Nx1 array of category values
%       -- trials information prevents correlating data that are from
%          different trials
% range is array of timeshifts, range = [-150:150] for -5 seconds to 5
% seconds, assuming 30 hz data.
%
%% How correlation is calculated
% For each lag point, we shift d1 or d2. The tail ends of the d1 and d2
% shift are not part of the final correlation calculation.
% The correlation value is the logical expression,
%   logic = (d1_not_zero) & (d1 == d2) & (trials_equal) & (trial_not_zero)
%   correlation = sum(logic) / sum(trials_equal & trial-not-zero)
% positive means d2 leads, negative means d1 leads
%%
if size(d1,1) > 1
    d1 = d1';
end
if size(d2,1) > 1
    d2 = d2';
end
if size(trials,1) > 1
    trials = trials';
end

res = zeros(1, length(range));

for l = 1:length(range)
    lag = range(l);
    if lag == 0
        trialsmatch = trials ~= 0;
        res(l) = sum(d1 == d2 & d1 ~= 0 & trialsmatch) / sum(trialsmatch);
    end
    if lag < 0
        d2part = d2(abs(lag)+1:end);
        d1part = d1(1:length(d2part));
        trials2part = trials(abs(lag)+1:end);
        trials1part = trials(1:length(trials2part));
        trialsmatch = trials1part == trials2part & trials1part ~= 0;
        log = (d1part == d2part & d1part ~= 0) & trialsmatch;
%         view = cat(1, d1part, d2part, trials1part, trials2part, log);
        res(l) = sum(log) / sum(trialsmatch);
    end
    if lag > 0
        d1part = d1(lag+1:end);
        d2part = d2(1:length(d1part));
        trials1part = trials(lag+1:end);
        trials2part = trials(1:length(trials1part));
        trialsmatch = trials1part == trials2part & trials1part ~= 0;
        log = (d1part == d2part & d1part ~= 0) & trialsmatch;
%         view = cat(1, d1part, d2part, trials1part, trials2part, log);
        res(l) = sum(log) / sum(trialsmatch);
    end
end
end