function divided = cont_divide(cont, divisor)
% Divide the values in a continuous variable by a constant value.
%
% usage:
%   dividend = cont_divide(cont_variable, divisor)
%
%
% The return value is another continual variable, where the value for each
% time stamp has been divided by the divisor.


divided = horzcat(cont(:, 1), cont(:, 2:end) / divisor);
