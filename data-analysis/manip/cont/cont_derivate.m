function res = cont_derivate(cont)
%cont_derivate   Calcuate the derivate of cont data
%
% res = cont_derivate(cont)
%
res (:,1) = cont(1:end-1,1);
for i=2:size(cont,2)
    res(:,i) = diff(cont(:,i)) ./ diff(cont(:,1));
end
end
