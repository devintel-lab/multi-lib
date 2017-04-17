function record_variable_log(sdata)
fid = fopen(fullfile(get_multidir_root(), 'record_variable_log.txt'), 'a');
tolog = sprintf('%d,%s,%s,%s\n', sdata.info.subject, sdata.variable, sdata.info.user, sdata.info.timestamp);
fwrite(fid, tolog);
fclose(fid);
end