function [cstream] = cstream_shared(data, p)
%
% generate a cstream containing the shared values in a set of variables 
%[cstream] = cstream_shared(data, p)
% this function takes a cell array of cstream variables that are already
% timely synched and with the same dimension, and then generate a new combined cstream with non-zero items
% in the new stream referring to values that are above a pre-defined threshould p, indicating the consensus between those variables. 
%
% Data is a cell array of cstream variables
% p is the threshold of the consensus 0<p<1
% cstream is a return cstream variable nx2 
%
% there are two main usages of this funciton.   
% 1. finding the shared moments of multiple cevent varialbes. setting p =
% 1, it is like a logical AND opertion for categorical events. 
% 
% 2. finding the consensus of the data. In the case that each cevent is the
% data from one person, we can call this function to get the concensus
% (e.g. 80% of Ss are looking at a location). Another example is a set of
% cevent derived from the same person, this function can be used to
% calculate the person is both looking at, manipulating, and heading
% toward, naming the same object, for instance. 
%
% Plus, this funciton is more general than binary event-based operations,
% therefore it can be used instead of event_and(). 
%

nvar = size(data,2);

if nvar < 2 
    fprintf(1,'you need to input at least more than two variables');
    return; 
elseif ((p>1) || (p<0))
    fprintf(1, 'the consensus parameter should be between 0 and 1'); 
    return; 
end;

% check timestamps in all the variables, they should be the same (synched)
for i= 1 : nvar-1
    if (size(data{i},1) ~= size(data{i+1},1))
        fprintf(1, 'variables have different lengths\n');
        return; 
    end;
    if (data{i}(:,1) ~= data{i+1}(:,1))
        fprintf(1,'data are not synched \n');
        return;
    end;
end;

% extracting value columns
for i = 1 : nvar
    data1(:,i) = data{i}(:,2);
end;

% ini a new stream
cstream = zeros(size(data{1}));
cstream(:,1) = data{1}(:,1); 

% extracting shared moments (the total number of shared elements is greater than the threshold) 
for i = 1 : size(data1,1)
    list = sort(unique(data1(i,:)));
    freq = histc(data1(i,:), list);
    [temp index] = max(freq);
    if ( freq(index)/sum(freq) >= p)
        cstream(i,2) = list(index);
         
    end;
end;


