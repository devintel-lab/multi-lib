function make_inhand_number_of_objects(IDs, obj_list)

if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end

if ~exist('obj_list', 'var') || isempty(obj_list)
    obj_list = [1 2 3];
end

agents = {'child','parent'};

sub_list = subs;

for s = 1 : numel(sub_list)
    sub = sub_list(s);
    for a = 1 : numel(agents)
        agent = agents{a};
        
        try 
           data = []; temp =[]; data_per_obj = [];
           for o = 1 : numel(obj_list)
               variable_name = sprintf('cstream_inhand_obj%d_%s',o,agent);
               temp = get_variable(sub, variable_name);
               index = find(temp(:,2) > 0);
               temp(index,2) = 1; 
               data_per_obj(:,o) = temp(:,2);
           end;
           data(:,1) = temp(:,1);
           data(:,2) = sum(data_per_obj,2);
           
%            trial_time = get_trial_times(sub);
%            new_data = cont_extract_ranges(data,[trial_time(1,1) ...
%                                trial_time(end,2)]);
           variable_name = sprintf('cstream_inhand_num-of-objects_%s',agent);
           %            record_variable(sub, variable_name, new_data{1});
           record_variable(sub, variable_name, data);
        catch ex
            disp(ex.message);
            fprintf('skipping subject %d, %s\n', sub, agent);
            continue;
        end;
    end;
end;
