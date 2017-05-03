clear;
subs = 'all';
diary('exception_log.txt');

for a = [1 2 3 4 5 6 7]
    master_data_vis(subs, a);
end

try
    run_visualize_basic_stats_per_object(subs);
catch ME
    disp(ME)
end


try
    for a = [1 2 3 4]
        master_vis_hist(subs, a);
    end
catch ME
    disp(ME);
end


try
    run_cross_correlation_plots(subs);
catch ME
    disp(ME);
end

diary off