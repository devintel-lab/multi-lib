function extract_relative_measures(var_list, subexpID, filename, args)

subs = cIDs(subexpID);
if ~iscell(var_list)
    var_list = {var_list};
end
measure = cell(1000,1000);
allsubs = zeros(size(measure,1),1);
allsubs(1:numel(subs),1) = subs;
h1 = 'subid,,';
h2 = sprintf('base:%s,total_number,total_trial_time', args.cevent_name);

absidx = 1;
relidx = 1;
propidx = 1;
for v = 1:numel(var_list)
    data_type = get_data_type(var_list{v});
    h1 = cat(2, h1, ',', var_list{v});
    switch data_type
        case {'cevent', 'event', 'cstream'}
            for t = 1:numel(args.prop_threshold{propidx})
                tt = args.prop_threshold{propidx}(t);
                if ~isempty(tt)
                    h1 = cat(2, h1, ',');
                    h2 = cat(2, h2, sprintf(',PROP_%.2f', tt));
                end
            end
            propidx = propidx + 1;
        case {'cont'}
            if isfield(args, 'abs_threshold')
                for t = 1:numel(args.abs_threshold{absidx})
                    tt = args.abs_threshold{absidx}(t);
                    if ~isempty(tt)
                        h1 = cat(2, h1, ',');
                        h2 = cat(2, h2, sprintf(',ABS_%.2f', tt));
                    end
                end
                absidx = absidx + 1;
            end
            if isfield(args, 'rel_threshold')
                for t = 1:numel(args.rel_threshold{relidx})
                    tt = args.rel_threshold{relidx}(t);
                    if ~isempty(tt)
                        h1 = cat(2, h1, ',');
                        h2 = cat(2, h2, sprintf(',REL_%.2f', tt));
                    end
                end
                relidx = relidx + 1;
            end
    end
    h1 = h1(1:end-1);
end

for s = 1:numel(subs)
    c = 1;
    absidx = 1;
    relidx = 1;
    propidx = 1;
    for v = 1:numel(var_list)
        data_type = get_data_type(var_list{v});
        if strcmp(data_type, 'event')
            newargs = args;
            newargs = rmfield(newargs, 'label_matrix');
            [~,e,st,~] = get_chunks(var_list{v}, subs(s), newargs);
        else
            [~,e,st,~] = get_chunks(var_list{v}, subs(s), args);
        end
        if v == 1
            if ~isempty(e)
                measure{s,c} = size(e.individual_ranges,1);
            else
                measure{s,c} = NaN;
            end
            c = c + 1;
            gt = get_trial_times(subs(s));
            measure{s,c} = sum(gt(:,2) - gt(:,1));
            c = c + 1;
        end
        switch data_type
            case {'cevent', 'event'}
                for t = 1:numel(args.prop_threshold{propidx})
                    tt = args.prop_threshold{propidx}(t);
                    if ~isempty(tt)
                        if ~isempty(st{1})
                            pstats = st{1}.individual_prop;
                            if ~isempty(strfind(var_list{v}, 'motion'))
                                measure{s,c} = sum(pstats < tt)/size(pstats,1);
                            else
                                measure{s,c} = sum(pstats > tt)/size(pstats,1);
                            end
                        else
                            measure{s,c} = NaN;
                        end
                        c = c + 1;
                    end
                end
                propidx = propidx + 1;
            case {'cstream'}
                for t = 1:numel(args.prop_threshold{propidx})
                    tt = args.prop_treshold{propidx}(t);
                    if ~isempty(tt)
                        if ~isempty(st{1})
                            pstats = st{1}.cevent_stats.individual_prop;
                            measure{s,c} = sum(pstats > tt)/size(pstats,1);
                        else
                            measure{s,c} = NaN;
                        end
                        c = c + 1;
                    end
                end
                propidx = propidx + 1;
            case {'cont'}
                for t = 1:numel(args.abs_threshold{absidx})
                    tt = args.abs_threshold{absidx}(t);
                    if ~isempty(tt)
                        if ~isempty(st{1})
                            tstats = st{1}.individual_mean;
                            measure{s,c} = sum(tstats > tt)/size(tstats,1);
                        else
                            measure{s,c} = NaN;
                        end
                        c = c + 1;
                    end
                end
                absidx = absidx + 1;
                for t = 1:numel(args.rel_threshold{relidx})
                    tt = args.rel_threshold{relidx}(t);
                    if ~isempty(tt)
                        if ~isempty(st{1})
                            rstats = st{2}.individual_mean;
                            measure{s,c} = sum(rstats > tt)/size(rstats,1);
                        else
                            measure{s,c} = NaN;
                        end
                        c = c + 1;
                    end
                end
                relidx = relidx + 1;
        end
    end
end

logmat = cellfun(@isempty, measure);
measure(all(logmat, 2),:) = [];
measure(:,all(logmat,1)) = [];
allsubs = allsubs(all(logmat,2) == 0,1);

datamatrix = cell2mat(measure);
datamatrix = [allsubs datamatrix];
log = all(isnan(datamatrix), 1);
datamatrix(:,log) = [];
hd = {h1, h2};
for h = 1:2
    head = hd{h};
    head = strrep(head, ',', ' ,');
    head = strsplit(head, ',');
    head(log) = [];
    head = strjoin(head, ',');
    head(isspace(head)) = '';
    hd{h} = head;
end

write2csv(datamatrix, filename, hd);
end