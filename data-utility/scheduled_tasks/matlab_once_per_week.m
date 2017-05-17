clear;
subs = 'all';
diary('/space/CORE/scheduled_tasks/exception_log.txt');

try
    for a = [1 2 3 4 5 6 7]
        master_data_vis(subs, a);
    end
catch ME
    disp(ME.message);
end

try
    for a = [1 2 3]
        run_correlation_plots(subs, a);
    end
catch ME
    disp(ME.message);
end


try
    run_visualize_basic_stats_per_object(subs);
catch ME
    disp(ME.message)
end


try
    for a = [1 2 3 4]
        master_vis_hist(subs, a);
    end
catch ME
    disp(ME.message);
end

try
    run_cross_correlation_plots(subs);
catch ME
    disp(ME.message);
end

diary off