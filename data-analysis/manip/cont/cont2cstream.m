function cstream_data = cont2cstream(var_data, param)
% cont2cstream  Convert cont data to cstream data     
%  USAGE:
%    cstream_data = cont2cstream(var_data, param);
%
%    param: 
%      param.nseg: the length of the cstream to be generated. (Now it must be divisible by length of var_data) 
%      param.alphabet_size: the number of categories/symbols
%
%    Example: 
%    cstram_data = cont2cstream(var_data, struct('nseg', size(var_data,1), 'alphabet_size', 16)); 
%
data = var_data(:,2);
data_len = length(data);
nseg = param.nseg;
alphabet_size = param.alphabet_size;

% nseg must be divisible by data length
if (mod(data_len, nseg))    
    disp('nseg must be divisible by the data length. Aborting ');
    return;  
end;

str = timeseries2symbol(data, data_len, data_len, alphabet_size);
if size(str,1) == 1
    str = str';
end
cstream_data = [var_data(:,1), str];
