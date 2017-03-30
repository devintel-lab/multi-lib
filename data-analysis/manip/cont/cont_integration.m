function res = cont_integration(cont)
%cont_integration   Calcuate the integration of cont data
%
% res = cont_integration(cont)
%
res = trapz(cont(:,1), cont(:,2));
end
