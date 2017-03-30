function s2karray = sid2kid(ID)
subs = cIDs(ID);

kids = zeros(numel(subs),2);

for i = 1:numel(subs)
    info = get_subject_info(subs(i));
    kids(i,1) = subs(i);
    kids(i,2) = info(4);
end

s2karray = kids;

end