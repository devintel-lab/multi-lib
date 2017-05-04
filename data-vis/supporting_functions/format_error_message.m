function format_error_message(error_ME, prefix)
if ~exist('prefix', 'var') || isempty(prefix)
    prefix = '';
end
towrite = sprintf('%s\t%s\t\t\n', prefix, error_ME.message);
for s = 1:length(error_ME.stack)
    towrite = cat(2, towrite, sprintf('\t\t%s\t%d\n', error_ME.stack(s).file, error_ME.stack(s).line));
end
fprintf('%s', towrite);
end