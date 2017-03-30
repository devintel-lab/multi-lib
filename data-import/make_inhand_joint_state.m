function make_inhand_joint_state(IDs)

if numel(num2str(IDs(1))) > 2
    subs = IDs;
else
    subs = list_subjects(IDs);
end


% child/parent joint holding states 
%  0 0 = 1
%  0 1 = 2
%  1 0 = 3 child holding ,parent not
%  1 1 = 4

sub_list = subs;
agents = {'child','parent'};
for s = 1 : numel(sub_list)
    sub = sub_list(s);
    new_data = []; data = [];
    for a = 1 : numel(agents)
        agent = agents{a};
        
        try 
            
            variable_name = sprintf('cstream_inhand_num-of-objects_%s',agent);
      
        catch ex
            disp(ex.message);
            fprintf('skipping subject %d, %s\n', sub, agent);
            continue;
        end;
        temp =  get_variable(sub, variable_name);
        index = find(temp(:,2) > 0);
        temp(index,2) = 1; 
        if a == 2
            if size(temp,1) > size(data,1)
                data(:,a) = temp(1:size(data,1),2);
            else
                data(:,a) = data(:,1);
                data(1:size(temp,1),a) = temp(:,2);
            end;
        else
            data(:,a) = temp(:,2);
        end;      
    end;
    new_data(:,1) = temp(:,1);
    new_data(:,2) = ones(size(temp(:,2)));
    index = intersect(find(data(:,1) == 0), find(data(:,2) == 1));
    new_data(index,2) = 2;
    index = intersect(find(data(:,1) == 1), find(data(:,2) == 0));
    new_data(index,2) = 3;
    index = intersect(find(data(:,1) == 1), find(data(:,2) == 1));
    new_data(index,2) = 4;
    variable_name = 'cstream_inhand_joint-state_both';
    record_variable(sub, variable_name, new_data);
    
    new_data2 = cstream2cevent(new_data);
    variable_name = 'cevent_inhand_joint-state_both';
    record_variable(sub, variable_name, new_data2);
end;
