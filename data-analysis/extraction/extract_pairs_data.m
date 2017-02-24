function [allpairs, cev1wo, cev2wo] = extract_pairs_data(cev1data, cev2data, timing_relation, mapping, args)

if ~exist('args', 'var') || isempty(args)
    args = struct();
end

if ~isfield(args, 'cevent_trials')
    args.cevent_trials = [];
end

if ~isfield(args, 'first_n_cev1')
    args.first_n_cev1 = [];
end

if ~isfield(args, 'last_n_cev1')
    args.last_n_cev1 = [];
end

if ~isfield(args, 'first_n_cev2')
    args.first_n_cev2 = [];
end

if ~isfield(args, 'last_n_cev2')
    args.last_n_cev2 = [];
end

if ~exist('mapping', 'var')
    mapping = [];
end

if ~isfield(args, 'pairtype')
    args.pairtype = ones(1, numel(mapping));
end
allpairs = [];
cev1wo = [];
cev2wo = [];
if ~isempty(cev1data) && ~isempty(cev2data)
    cev1data = sortrows(cev1data, [1 2 3]);
    cev2data = sortrows(cev2data, [1 2 3]);
    
    cev1data = add_trial_idx(cev1data, args.cevent_trials);
    cev2data = add_trial_idx(cev2data, args.cevent_trials);
    
    on2 = cev2data(:,1);
    off2 = cev2data(:,2);
    
    prealloc = cell(size(cev1data,1),1);
    for c = 1:numel(prealloc)
        on1 = cev1data(c,1);
        off1 = cev1data(c,2);
        
        log = eval(timing_relation);
        cev2matched = cev2data(log,:);
        prealloc{c,1} = [repmat(cev1data(c,:), size(cev2matched,1), 1), cev2matched];
    end
    
    allpairs = vertcat(prealloc{:});
    
    if ~isempty(allpairs)
        % on off cat idx trial on off cat idx trial
        % 1   2   3   4    5    6  7   8   9   10
        log = allpairs(:,5) == allpairs(:,10);
        allpairs = allpairs(log,:);
        
        % only consider the pairs specified in mapping
        if ~isempty(mapping)
            if ~iscell(mapping)
                mapping = num2cell(mapping, 2);
            end
            for d = 1:size(allpairs, 1)
                pair = allpairs(d,[3 8]);
                log = cellfun(@(a) isequal(pair, a), mapping);
                if sum(log) > 0
                    allpairs(d,11) = args.pairtype(log);
                else
                    allpairs(d,11) = 0;
                end
            end
            allpairs(allpairs(:,11) == 0,:) = [];
        else
            % fill pairtype column with 'cat0cat'
            cat1 = arrayfun(@num2str, allpairs(:,3), 'un', 0);
            cat2 = arrayfun(@num2str, allpairs(:,8), 'un', 0);
            bothcat = cellfun(@(a,b) str2double(strcat(a, '0', b)), cat1, cat2);
            allpairs(:,11) = bothcat;
        end
        
        % if firstflag, force 1-1 mapping
        uidx = unique(allpairs(:,4));
        idx_keep = [];
        for u = 1:numel(uidx)
            idx1 = find_first_last_n(allpairs(:,4), uidx(u), args.first_n_cev1, 'first');
            idx2 = find_first_last_n(allpairs(:,4), uidx(u), args.last_n_cev1, 'last');
            idx3 = find_first_last_n(allpairs(:,9), uidx(u), args.first_n_cev2, 'first');
            idx4 = find_first_last_n(allpairs(:,9), uidx(u), args.last_n_cev2, 'last');
            idx_keep = cat(1, idx_keep, idx1, idx2, idx3, idx4);
        end
        
        idx_keep = unique(idx_keep);
        allpairs = allpairs(idx_keep, :);
        allpairs(:,5) = []; % get rid of first trial column, it is redundant
        log = ~ismember(cev1data(:,4), allpairs(:,4));
        cev1wo = cev1data(log,:);
        log = ~ismember(cev2data(:,4), allpairs(:,8));
        cev2wo = cev2data(log,:);
    end
end
end
function log = less(t1,t2,thres)
less_dif = t2 - t1;
log = less_dif > -0.001;
if exist('thres', 'var')
    log = log & less_dif <= thres;
end
end

function log = more(t1,t2,thres)
more_dif = t2 - t1;
log = more_dif > -0.001;
if exist('thres', 'var')
    log = log & more_dif >= thres;
end
end

function idx_column = find_first_last_n(idx_column, idx, n, first_last)
if ~isempty(n)
    idx_column = find(idx_column==idx, n, first_last);
else
    idx_column = (1:size(idx_column, 1))';
end
end

function cev = add_trial_idx(cev, trials)
if isempty(trials)
    cev(:,5) = 1;
else
    cev = extract_ranges(cev, 'cevent', trials);
    for c = 1:numel(cev)
        cev{c}(:,5) = trials(c,3);
    end
    cev = vertcat(cev{:});
end
cev(:,4) = (1:size(cev,1))';
end
