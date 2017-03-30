function out = get_num_obj(subid)

subs = cIDs(subid);

stim = fullfile(get_multidir_root, 'stimulus_table.txt');
fid = fopen(stim, 'r');
if fid > 0
    data = textscan(fid, '%d %d %d %s %s %d %s %d','Headerlines', 1, 'delimiter', ',', 'EmptyValue', -Inf);
else
    error('file did no open correctly');
end
fclose(fid);

data = horzcat(data{[1 2 3]});
out = arrayfun(@(a) sum(data(:,1) == a & data(:,3) == 1), sub2exp(subs));



% out = 0;
% vars = list_variables(subid);
% for o = [3 5]
%     log = strfind(vars, sprintf('obj%d', o));
%     if sum(cellfun(@(a) ~isempty(a), log)) > 0
%         out = o;
%     end
% end
end
