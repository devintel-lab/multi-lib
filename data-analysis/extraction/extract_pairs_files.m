function [allpairs, cev1wo, cev2wo] = extract_pairs_files(filename1, filename2, timing_relation, mapping, savefilename, args)

if ~exist('args', 'var') || isempty(args)
    args = struct();
end

if ~isfield(args, 'files_numheaders')
    args.files_numheaders = zeros(1, 2);
end

if ~isfield(args, 'files_columns')
    args.files_columns = cell(1, 2);
end

if ~exist('mapping', 'var') || isempty(mapping)
    mapping = (1:100)';
    mapping(:,2) = args.mapping(:,1);
end

if ~isfield(args, 'cevent_trials_numheaders')
    args.cevent_trials_numheaders = 0;
end

if ~isfield(args, 'cevent_trials_columns')
    args.cevent_trials_columns = [];
end

if isfield(args, 'cevent_trials')
    if ischar(args.cevent_trials)
        args.cevent_trials = load_data_from_file(args.cevent_trials, args.cevent_trials_numheaders, args.cevent_trials_columns);
    end
end

if ~isfield(args, 'cevent_trials')
    args.cevent_trials = [];
end

cev1 = load_data_from_file(filename1, args.files_numheaders(1), args.files_columns{1});
cev2 = load_data_from_file(filename2, args.files_numheaders(2), args.files_columns{2});

[allpairs, cev1wo, cev2wo] = extract_pairs_data(cev1, cev2, timing_relation, mapping, args);

h1 = sprintf('%s,%s,,,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), filename1, filename2);
h2 = sprintf('onset, offset, cat, index, onset, offset, cat, index, trialid, pairid');
headers = {h1, h2};

if exist('savefilename', 'var') && ~isempty(savefilename)
    write2csv(allpairs, savefilename, headers);
    
    h1 = sprintf('%s,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), filename1);
    h2 = sprintf('onset, offset, cat, index, trialid');
    headers = {h1, h2};
    write2csv(cev1wo, strrep(savefilename, '.csv', '_cev1wo.csv'), headers);
    
    h1 = sprintf('%s,%s,,,,,',strrep(strrep(timing_relation, ' ', '_'), ',', ';'), filename2);
    headers = {h1, h2};
    write2csv(cev2wo, strrep(savefilename, '.csv', '_cev2wo.csv'), headers);
end
end