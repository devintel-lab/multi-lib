function cont_added = cont_add(varargin)
% cont_add makes a new cont. variable by adding up several other ones
%
% USAGE:
% cont_add(VAR1 [, VAR2, VAR3, ...])
%   Computes the sum at each time step of all the variables, creating a new
%   cont. variable with the timestamps from VAR1.
%
% The variables must all have the same number of rows.
%
% This function takes multiple cont variables and produces one cont
% variable.  To take one cont variable and compute the sum of all its
% values, use cont_sum.
%
% See also: CONT_SUM, CONT_DIVIDE
%

% re-form the input args into a single matrix
all_together = horzcat(varargin{:});
values = sum(all_together(:, 2:2:end), 2);

cont_added = horzcat(all_together(:, 1), values);

