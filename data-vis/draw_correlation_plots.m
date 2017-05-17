function draw_correlation_plots(subexpIDs, varname, measures, directory, nametag, args, modes)
try
    if ~exist(directory, 'dir')
        error('%s does not exist, please create it first\n', directory);
    end

    if ~exist('modes', 'var') || isempty(modes)
        modes = [1 2 3];
    end
    
    [~,allsubs] = cIDs('all');
    
    % make multilong experiments have equal number of subjects
    log = ismember(allsubs(:,2), [70 71 72 73 74 75]);
    partsubs = allsubs(log,:);
    maxsub = max(partsubs(:,1) - partsubs(:,2)*100);
    longsubs = (1:maxsub)';
    uexp = [70 71 72 73 74 75];
    uallsubs = cell(numel(uexp),1);
    for u = 1:numel(uexp)
        uallsubs{u,1} = longsubs + uexp(u)*100;
    end
    uallsubs = vertcat(uallsubs{:});
    allsubs = allsubs(:,1);
    allsubs = cat(1, allsubs, uallsubs);
    allsubs = sort(unique(allsubs));
    
    nanmat = allsubs;
    nanmat(:,[2 3]) = NaN;
    
    subs = cIDs(subexpIDs);
    
    args.persubject = 1;
    if ~iscell(measures)
        measures = {measures};
    end
    args.measures = {measures};
    
    [age, ~, log] = get_age_at_exp(subs);
    
    subs = subs(log);
    [d,~] = extract_multi_measures(varname, subs, [], args);
    
    if ~isempty(d)
        [~, idx, log] = intersect_order(d(:,1), subs);
        
        d = d(idx,:);
        age = age(log);
        
        % all without text
        if ismember(1, modes)
            for m = 1:numel(measures)
                measure = measures{m};
                figure;
                gscatter(age, d(:,m+3), d(:,2));% get_colors_v2(unique(d(:,2))));
                set(gcf, 'position', [100 100 1280 720]);
                title(strfix(nametag));
                ylabel(strfix(measure));
                xlabel('age');
                legend('location', 'northeastoutside');
                
                figname = fullfile(directory, sprintf('%s_%s_vs_age_all', nametag, measure));
                export_fig(gcf, figname, '-png', '-a1', '-r90', '-nocrop');
                close gcf;
                
                [~, idx, log] = intersect_order(d(:,1), allsubs);
                nanmat(log,2) = d(idx, m+3);
                nanmat(log,3) = age(idx);
                
                headers = sprintf('subject,%s:%s,age', nametag, measure);
                write2csv(nanmat, fullfile(directory, sprintf('%s_%s_vs_age_all.csv', nametag, measure)), headers);
            end
        end
        
        log = ~ismember(d(:,2), [70 71 72 73 74 75 76]);
        if sum(log) > 0
            if ismember(2, modes)
                tage = age(log);
                td = d(log,:);
                % non-multilong with text
                for m = 1:numel(measures)
                    measure = measures{m};
                    figure;
                    gscatter(tage, td(:,m+3), td(:,2));
                    set(gcf, 'position', [100 100 1280 720]);
                    title(strfix(nametag));
                    ylabel(strfix(measure));
                    xlabel('age');
                    legend('location', 'northeastoutside');
                    
                    
                    for t = 1:size(td,1)
                        text(tage(t), td(t,m+3), sprintf('%d', td(t,1)), 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
                    end
                    
                    figname = fullfile(directory, sprintf('%s_%s_vs_age_reg', nametag, measure));
                    export_fig(gcf, figname, '-png', '-a1', '-r90', '-nocrop');
                    close gcf;
                end
            end
        end
        
        if sum(~log) > 0
            if ismember(3, modes)
                md = d(~log,:);
                uexp = unique(md(:,2));
                [~,idx] = ismember(md(:,2), uexp);
                longid = md(:,1) - md(:,2)*100;
                ulongid = unique(longid);
                % multilong without text
                for m = 1:numel(measures)
                    measure = measures{m};
                    figure;
                    gscatter(idx, md(:,m+3), md(:,2));
                    set(gcf, 'position', [100 100 1280 720]);
                    title(strfix(nametag));
                    ylabel(strfix(measure));
                    xlabel('age');
                    hold on;
                    
                    plothandles = cell(length(ulongid),1);
                    lulongsubs = plothandles;
                    i = 1;
                    for u = 1:length(ulongid)
                        log = ismember(longid, ulongid(u));
                        if sum(log) > 1
                            plothandles{i,1} = plot(idx(log), md(log,m+3));
                            lulongsubs{i,1} = ulongid(u);
                            i = i + 1;
                        end
                    end
                    
                    %                 for t = 1:size(idx,1)
                    %                     text(idx(t), md(t,m+3), sprintf('%d', md(t,1)), 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
                    %                 end
                    
                    plothandles = vertcat(plothandles{:});
                    lulongsubs = vertcat(lulongsubs{:});
                    
                    legendarray = arrayfun(@(a) sprintf('%02d', a), lulongsubs, 'un', 0);
                    legend(plothandles, legendarray, 'location', 'northeastoutside');
                    
                    set(gca, 'xtick', 1:length(uexp));
                    set(gca, 'xticklabel', uexp);
                    
                    figname = fullfile(directory, sprintf('%s_%s_vs_age_multilong', nametag, measure));
                    export_fig(gcf, figname, '-png', '-a2', '-r90', '-nocrop');
                    close gcf;
                end
            end
        end
    end
catch ME
    disp(ME.message);
end
    function strfixout = strfix(string)
        strfixout = strrep(string, '_', '\_');
    end

end