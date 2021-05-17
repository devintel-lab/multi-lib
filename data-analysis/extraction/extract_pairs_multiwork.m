function [allpairs, cev1wo, cev2wo] = extract_pairs_multiwork(subexpIDs, cev1, cev2, timing_relation, mapping, savefilename, args)
% see demo_extract_pairs_multiwork for documentation

[subs,~,subpaths] = cIDs(subexpIDs);
allpairs = cell(numel(subs), 1);
cev1wo = allpairs;
cev2wo = allpairs;
for s = 1:numel(subs)
    fprintf('%d\n', subs(s));
    cev1fn = fullfile(subpaths{s}, [cev1 '.mat']);
    cev2fn = fullfile(subpaths{s}, [cev2 '.mat']);
    args.cevent_trials = fullfile(subpaths{s}, 'cevent_trials.mat');
    [ap, c1wo, c2wo] = extract_pairs_files(cev1fn, cev2fn, timing_relation, mapping, [], args);
    allpairs{s,1} = [repmat(subs(s), size(ap,1),1) ap];
    cev1wo{s,1} = [repmat(subs(s), size(c1wo,1),1) c1wo];
    cev2wo{s,1} = [repmat(subs(s), size(c2wo,1),1) c2wo];
end
allpairs = vertcat(allpairs{:});
cev1wo = vertcat(cev1wo{:});
cev2wo = vertcat(cev2wo{:});

h1 = sprintf('%s,%s,,,,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), cev1, cev2);
h2 = sprintf('subid, onset, offset, cat, index, onset, offset, cat, index, trialid, pairid');
headers = {h1, h2};

if exist('savefilename', 'var') && ~isempty(savefilename)
    write2csv(allpairs, savefilename, headers);
    
    h1 = sprintf('%s,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), cev1);
    h2 = sprintf('subid, onset, offset, cat, index, trialid');
    headers = {h1, h2};
    write2csv(cev1wo, strrep(savefilename, '.csv', '_cev1wo.csv'), headers);
    
    h1 = sprintf('%s,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), cev2);
    headers = {h1, h2};
    write2csv(cev2wo, strrep(savefilename, '.csv', '_cev2wo.csv'), headers);
end
end
