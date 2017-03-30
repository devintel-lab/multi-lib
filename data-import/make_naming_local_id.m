function make_naming_local_id(IDs, fix)
% take cevent_naming and create a new one cevent_naming_local_id
% by changing the 3rd column from word IDs to local IDs (1/2/3)
% and aslo create a cstream variable

subs = cIDs(IDs);

if ~exist('fix', 'var') || isempty(fix)
    fix = 0;
end

for s = 1:numel(subs)
    exp_id = sub2exp(subs(s));
    %table is under multiwork/stimulus_table.txt
    switch exp_id
        case {14}
            table = [701 1; 550 2; 700 3; 555 1; 539 2; 554 3];
        case {19}
            table = [555 1; 554 3; 539 2; 550 2; 551 1; 549 3];
        case {29, 32, 34, 41, 43, 44, 49}
            table = [555 1; 539 2; 554 3;  701 1; 550 2; 700 3];
            switch subs(s)
                case {4108 4109}
                    table = [368 1; 359 2; 349 3; 2783 1; 372 2; 2782 3];
            end
        case {35}
            table = [1294 1; 716 2; 271 3; 945 1; 837 2; 1362 3];
        case {70}
            table = [1294 1; 716 2; 1078 3; 945 1; 2713 2; 1362 3];
        case {71}
            table = [549 1; 550 2; 554 3; 2828 1; 539 2; 2783 3];
        case {72}
            table = [368 1; 2846 2; 701 3; 359 1; 349 2; 372 3];
        case {73}
            table = [2969 1; 2967 2; 2968 3; 2970 1; 2972 2; 2971 3];
        case {74}
            table = [3117 1; 3118 2; 3116 3; 3113 1; 3111 2; 3114 3];
        case {75}
            table = [3204 1; 3206 2; 3205 3; 3208 1; 3210 2; 3207 3];
            
        otherwise
            error('No table for this exp ID');
    end;
    
    try
        naming = get_variable(subs(s), 'cevent_speech_naming');
        %check if naming includes the correct id numbers
        log = ~ismember(naming(:,3), table(:,1));
        if sum(log) > 0
            if fix
                record_variable_into_specified_directory(subs(s), 'extra_p', 'cevent_speech_naming', naming);
                naming(log,:) = [];
                record_variable(subs(s), 'cevent_speech_naming', naming);
            else
                error('cevent_speech_naming includes name ids not included in the table')
            end
        end
    catch ME
        disp(ME.message);
        fprintf (1,'skip subject :%d\n', subs(s));
        continue;
    end;
    naming_local_id = naming;
    for j = 1 : size(naming,1)
        index = find(naming(j,3) == table(:,1));
        naming_local_id(j,3) = table(index,2);
    end;
    record_variable(subs(s),'cevent_speech_naming_local-id', ...
        naming_local_id);
    
end
end

