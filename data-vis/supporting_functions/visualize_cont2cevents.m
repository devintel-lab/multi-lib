function cevent_data = visualize_cont2cevents(cont_data, sample_rate, data_max, convert_max_int, cont_value_offset, reverse_flag)

if ~exist('convert_range', 'var')
    convert_max_int = 100; % 100 colors
end

if ~exist('cont_value_offset', 'var')
    cont_value_offset = 0; % no offset
end

if ~exist('reverse_flag', 'var')
    reverse_flag = false; % no offset
end

if convert_max_int > 256
    error('The total number of color cannot exceed 256');
end

% convert_data_list = 1:convert_max_int;
data_range_rate = (data_max - 0) / (convert_max_int-1);

data_length = size(cont_data, 1);

cevent_data = nan(data_length,3);
cevent_data(:,1) = cont_data(:,1);
cevent_data(:,2) = cont_data(:,1)+sample_rate;

for cdidx = 1:data_length
    data_one = cont_data(cdidx, 2);
    new_data_one = floor((data_one)/data_range_rate)+1;
    
    if new_data_one > convert_max_int
        new_data_one = convert_max_int;
    end
    
    if reverse_flag
        new_data_one = convert_max_int - new_data_one + 1;
    end
    
    cevent_data(cdidx, 3) = new_data_one + cont_value_offset;
end
