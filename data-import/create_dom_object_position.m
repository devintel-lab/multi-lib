function create_dom_object_position(IDs)
%finds distance from center of frame to each dominant object, NaN otherwise
if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

person = {'child' 'parent'};
factor = {'big' 'dominant'};
threshold = {'' '-2x'};
for s = 1:numel(subs)
    for p = 1:numel(person)
        for f = 1:numel(factor)
            for t = 1:numel(threshold)
                factor_name = sprintf('cevent_vision_size_obj-%s%s_%s', factor{f}, threshold{t}, person{p});
                if has_variable(subs(s), factor_name)
                    factor_var = get_variable(subs(s), factor_name);
                    data_collection = [];
                    for o = 1:3
                        var = sprintf('cont_vision_min-dist_obj%d_%s', o, person{p});
                        if has_variable(subs(s), var)
                            var_data = get_variable(subs(s), var);
                            time_base = var_data(:,1);
                            cstr = cevent2cstream_v2(factor_var,[], [], time_base);
                            log = cstr(:,2) == o;
                            log_nan = log == 0;
                            var_data(log_nan,2) = NaN;
                            data_collection = cat(2, data_collection, var_data(:,2));
                        end
                    end
                    if ~isempty(data_collection)
                        %test to make sure there are 2 NaN values per row
                        log = isnan(data_collection);
                        log_not_nan = log == 0;
                        sum_log = sum(log_not_nan, 2);
                        all_nan = sum_log == 0;
                        log_multiple = sum_log > 1;
                        if sum(log_multiple) > 0
                            disp('warning, lines with more than 1 non-NaN values');
                            disp(subs(s));
                        else
                            %cat across
                            data_clone = data_collection;
                            data_clone(isnan(data_clone)) = 0;
                            final_data = sum(data_clone,2);
                            final_data(all_nan) = NaN;
                            final_data = [time_base final_data];
                            %record data
                            rec_name = sprintf('cont_vision_min-dist_obj-%s%s_%s', factor{f}, threshold{t}, person{p});
                            %                         disp(rec_name);
                            record_variable(subs(s), rec_name, final_data);
                        end
                    else
                        fprintf('Subject %d missing variable, cont_vision_min-dist\n', subs(s));
                    end
                else
                    fprintf('Subject %d missing variable, %s\n', subs(s), factor_name);
                end
            end
        end
    end
end