function summary = cont_sum(data)
%cont_sum  Return the sum of the cont data.
%   res = cont_sum(cont_data)
% This function takes the sum of all the values in one cont variable.
% If you want to add two cont variables, together, use cont_add.
% See also: CONT_ADD

summary = nansum(data(:,2:end),1);
return;
