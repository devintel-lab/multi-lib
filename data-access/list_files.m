function out = list_files(path, substring)
% out = lf(substring, path)
%
% Optional: string, path, filetype
% string is a space separated string with file name parts
% e.g. 'cstream inhand eye roi age'
% will return filenames that have all of those substrings (in any order) in the
% filename
%
% path is a parent directory where files are located
%

if ~exist('path', 'var') || isempty(path)
    path = fullfile(get_multidir_root(), '/data_vis/correlation/');
    filetype = '.csv';
else
    filetype = '';
end

d = dir(fullfile(path, sprintf('*%s', filetype)));
out = arrayfun(@(A) A.name, d, 'un', 0);

if exist('substring', 'var') && ~isempty(substring)
    if ~iscell(substring)
        substring = strsplit(substring, ' ');
    end
    
    log1 = cellfun(@(A) strfind(out, A), substring, 'un', 0);
    
    log2 = horzcat(log1{:});
    log3 = cellfun(@(A) ~isempty(A), log2);
    slog = sum(log3,2);
    log = slog == numel(substring);
    
    out = out(log);
end

end