function loaded_data = load_data_from_file(filename, numheaders, columns)
loaded_data = [];
if ~isempty(strfind(filename, '.mat'))
    if exist(filename, 'file')
        load(filename);
        loaded_data = sdata.data;
    end
else
    loaded_data = dlmread(filename, ',', numheaders, 0);
    if ~isempty(columns)
        loaded_data = loaded_data(:,columns);
    end
end