function test = make_select_one_from_many(IDs, corp)
%finds the largest, closest to center, most salient, and most dynamic
%object at each timestamp from child or parent view.
%subexpID is subject list or experiment list
%corp is [1 2] or [1] or [2] where 1 is child and 2 is parent

subs = cIDs(IDs);

person = {'child' 'parent'};

%keep order for these two lists;
variable_list = {
    'cont_vision_size'
    'cont_vision_min-dist'
    'cont_vision_M-#pixel'
    'cont_vision_dyn'
    };
rec_var_names = {
    'cstream_vision_size_obj-largest'
    'cstream_vision_min-dist_obj-closest'
    'cstream_vision_M_obj-salienest'
    'cstream_vision_dyn_obj-dyn-most'
    };

%all data goes into test structure that will be returned by the function
test = cell(1, numel(subs)*numel(variable_list)*numel(corp));
for s = 1 : numel(subs)
    for p = 1:numel(corp)
        personID = person{corp(p)};
        for v = 1:numel(variable_list)
            all_data = [];
            for o = 1:5
                varname = sprintf('%s_obj%d_%s', variable_list{v}, o, personID);
                if has_variable(subs(s), varname)
                    data = get_variable(subs(s), varname);
                    if o == 1
                        all_data = data;
                    else
                        all_data = cat(2, all_data, data(:,2));
                    end
                end
            end
            if ~isempty(all_data)
                if ~isempty(strfind(varname, 'min'))
                    [~, index] = min(all_data(:,2:end),[], 2);
                else
                    [~, index] = max(all_data(:,2:end),[], 2);
                end
                log = sum(all_data(:,2:end), 2) == 0;
                index(log) = 0;
                recdata = [all_data(:,1) index];
                recname = sprintf('%s_%s', rec_var_names{v}, personID);
                test{(s-1)*numel(corp)*numel(variable_list)+(p-1)*numel(variable_list)+v} = recdata;
                record_variable(subs(s), recname, recdata);
            end
        end
    end
end
end
