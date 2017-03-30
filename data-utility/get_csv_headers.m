function [out, i] =  get_csv_headers(csv)
% header lines should begin with a #
% i returns the line where the data should begin

out = cell(20,1);
i = 1;

fid = fopen(csv, 'r');
line = fgetl(fid);
while strcmp('#', line(1))
    out{i,1} = line;
    i = i + 1;
    line = fgetl(fid);
end
fclose(fid);

out(cellfun(@isempty, out)) = [];
end