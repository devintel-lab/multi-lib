function exps = sub2exp(subs)
%SUB2EXP Find what experiment each subject is in

exps = nan(size(subs));
sub_table = read_subject_table();

for S = 1:numel(subs)
    sub = subs(S);
    this_exp = sub_table(sub_table(:, 1) == sub, 2);
    
    if isempty(this_exp)
        error('No such subject %d', sub);
    end
    exps(S) = this_exp;
end
