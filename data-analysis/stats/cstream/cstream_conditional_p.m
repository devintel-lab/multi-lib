function cp = cstream_conditional_p(cstream_data)
% cstream_conditional_p  Calculate the contional probability of cstream.
%
% cp = cstream_conditional_p(cstream_data);
%
% cstream_data: input cstream
% cp : conditional probablity matrix, cp(X1,X2) is P(X2|X1), where X1X2 is bigram in
%      cstream and X1 appears right before X2.
% 

data = cstream_data(:,2);
sym_num = max(data);

cp = zeros(sym_num, sym_num);
% 
for i = 2:length(data)
    cp(data(i-1), data(i)) = cp(data(i-1), data(i)) + 1;
end

sums = sum(cp, 2);

for j = 1:sym_num
     cp(j,:) = cp(j,:) / sums(j);
end
