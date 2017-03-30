
function [] =  main_check_variables(sub_list, data_types, is_to_display, dir_name)
%
% this function performs data validation by checking several properties
% of the four data types. It goes through all the variables one by one
% and generate a report which will be either displayed (is_to_display =
% 1) or saved in  a set of report files (e.g. cstream_check_1401). In the
% later case, dir_name specifies the directory to save those files. 
%    
% e.g.    
%dir_name = '/ein/scratch/Zeth/variable_check';
%sub_list = [1401:1418];
%data_types = {'event_','cont_','cevent_','cstream_'}; 
%is_to_display = 0;  % 1 -- display; 0 - to a file
% then call this function 
%   main_check_variables(sub_list, data_types, is_to_display, dir_name)

for s = 1 : size(sub_list,2)
    subject = sub_list(s)
    for d  = 1 : size(data_types,2)
        data_type = data_types{d};
        listing = list_variables(subject); 
        
        if is_to_display ==1
            io = 1; 
        else
            file_name = sprintf('%s/%scheck_%d.txt',dir_name,data_type, subject);
            fid = fopen(file_name,'w');
            io = fid; 
        end;
        for i = 1 : size(listing,1)
            variable_name = listing{i};
            switch data_type 
              
              case 'cont_'
                if sum(strfind(variable_name, data_type)) > 0
                    data = get_variable(subject,variable_name); 
                    fprintf(io, ['***************************************' ...
                                 '*******\n']);
                    fprintf(io,'%s\n',variable_name);
                    
                    fprintf(io, ['%s\nmean:%5.2f, median:%5.2f, SD:%5.2f, ' ...
                               'min:%5.2f, max: %5.2f\n'],variable_name, mean(data(:,2)), median(data(:,2)),std(data(:,2)),min(data(:,2)),max(data(:,2)));
                  
                    bin_edge = linspace(min(data(:,2)), max(data(:,2)),10);
                    hist_data = histc(data(:,2),bin_edge) ./size(data,1);
                    fprintf(io,'bin: '), fprintf(io, '%5.2f ', bin_edge); fprintf(io,'\n');
                    fprintf(io, 'prop:'); fprintf(io,'%5.2f ', hist_data);
                    fprintf(io, '\n**********************************************\n\n');
                end;
                
              case  'cstream_'
                if sum(strfind(variable_name, data_type)) > 0
                    data = get_variable(subject,variable_name); 
                    item_list = unique(data(:,2));
                    num_item = []; 
                    for n_item = 1 : size(item_list,1)
                        num_item(n_item) = size(find(data(:,2) == item_list(n_item)),1)/size(data,1);
                    end;
                    fprintf(io, '**********************************************\n');
                    fprintf(io,'%s\n',variable_name);
                    fprintf(io, 'categories:');fprintf(io, '%5d ', item_list); fprintf(io,'\n');
                    fprintf(io, '      prop:');fprintf(io, '%5.2f ', ...
                                                       num_item); ...
                        fprintf(io,'\n');
                    
                    fprintf(io, '# of switches:%5d\n',size(find(diff(data(:,2) ~=0)),1));
                    fprintf(io, '\n**********************************************\n\n');
                end;
            
              case  'cevent_'
                if sum(strfind(variable_name, data_type)) > 0
                    data = get_variable(subject,variable_name); 
                    item_list = unique(data(:,3));
                    num_item = []; mean_dur_item = []; median_dur_item = ...
                        [];
                    min_dur_item = []; max_dur_item = [];
                    
                    for n_item = 1 : size(item_list,1)
                        index = find(data(:,3) == item_list(n_item));
                        num_item(n_item) = size(index, 1);    
                        all_duration = data(index,2) - data(index,1); 
                        mean_dur_item(n_item) = mean(all_duration);
                        median_dur_item(n_item) = median(all_duration);
                        min_dur_item(n_item) = min(all_duration);
                        max_dur_item(n_item) = max(all_duration);
                    end;
                    fprintf(io, '**********************************************\n');
                    fprintf(io,'%s\n',variable_name);
                    fprintf(io, ' # of cevents: %d\n', size(data,1));
                    fprintf(io, '   categories:');fprintf(io, '%6d ', ...
                                                          item_list); fprintf(io,'\n');
                    fprintf(io, '# of switches:');fprintf(io, '%6.2f ', num_item); fprintf(io,'\n');

                    fprintf(io, 'mean duration:');fprintf(io, '%6.2f ', ...
                                                          mean_dur_item); fprintf(io,'\n');                   
                    fprintf(io, 'med  duration:');fprintf(io, '%6.2f ', median_dur_item); fprintf(io,'\n');
                    fprintf(io, 'min  duration:');fprintf(io, '%6.2f ', min_dur_item); fprintf(io,'\n');
                    fprintf(io, 'max  duration:');fprintf(io, '%6.2f ', max_dur_item); fprintf(io,'\n');

                    fprintf(io, '\n**********************************************\n\n');
                end;
            
                case  'event_'
                if sum(strfind(variable_name, data_type)) > 0 && ...
                        sum(strfind(variable_name,'cevent_')) == 0
                    data = get_variable(subject,variable_name);
                    all_duration = data(:,2) - data(:,1); 
                    fprintf(io, '**********************************************\n');
                    fprintf(io,'%s\n',variable_name);
                    fprintf(io, ' # of cevents: %d\n', size(data,1));
                    fprintf(io, [' duration, mean:%6.2f, median:%6.2f; ' ...
                                 'min:%6.2f,max:%6.2f'], mean(all_duration), ...
                            median(all_duration), min(all_duration), max(all_duration));
                    fprintf(io, '\n**********************************************\n\n');

                end;
                
            end;
        end;
        
        if is_to_display == 0
            fclose(io); 
        end;
    end;
end;