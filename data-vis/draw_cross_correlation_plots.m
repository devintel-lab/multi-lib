function draw_cross_correlation_plots(subexpIDs, var1, var2, range_sec, directory, nametag)
% see demo_draw_cross_correlation_plots for documentation

rate = 30;

subs = cIDs(subexpIDs);

lagall = cell(numel(subs),1);
suball = cell(1,numel(subs));

range_samp = range_sec*rate;
windowrange = range_samp(1):range_samp(2);

for s = 1:numel(subs)
    sub = subs(s);
    fprintf('%d\n', sub);
    try
        log = cellfun(@(a) has_variable(sub, a), {var1, var2});
        if all(log)
            gt = get_trial_times(sub);
        
            tb = (gt(1,1):1/rate:gt(end,2))';
            trials = get_variable(sub, 'cstream_trials');
            x = get_variable(sub, var1);
            y = get_variable(sub, var2);
        
            [~,trials,x,y] = align_cstreams(tb, trials, x, y);
        
            lag = xcorrmod(x(:,2),y(:,2),trials(:,2),windowrange);
            if ~all(lag==0)
                lagall{s,1} = lag';
                suball{1,s} = sub;
            end
        end
    catch ME
        disp(ME.message)
        continue
    end
end

suball = horzcat(suball{:});
lagall = horzcat(lagall{:});

lagmean = mean(lagall,2, 'omitnan');

lagall = cat(2, (windowrange/rate)', lagall, lagmean);

header = sprintf('%d,', suball);
header = cat(2, 'timerange,', header, 'meanallsub');

clf;
plot(windowrange/rate, lagmean);
hold on;
yr = get(gca, 'ylim');
plot([0 0], [yr(1) yr(2)]);
xlabel('negative means var1 leads, positive means var2 leads (seconds)');
title([strrep(nametag, '_', '\_') ' : prop var1 == var2, non-zero']);
set(gcf, 'position', [100 100 1280 720]);

export_fig(gcf, fullfile(directory, nametag), '-png');

write2csv(lagall, fullfile(directory, [nametag '.csv']), header);
