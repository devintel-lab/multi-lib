for a = 1:5
    try
        master_data_vis2('all', a);
    catch ME
        continue;
    end
end