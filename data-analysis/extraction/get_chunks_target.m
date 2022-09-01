function [out, targets] = get_chunks_target(chunks, targets, label_matrix, datatype)
% out = get_chunks_target(chunks, targets, label_matrix, operation)

if iscell(targets)
    out = cell(numel(targets),1);
    for o = 1:numel(targets)
        out{o,1} = get_chunks_target(chunks{o}, targets{o}, label_matrix, datatype);
    end
    return
end

if ~iscell(chunks)
    error('chunks must be cell array when targets is not');
end
%continuous data types
if size(chunks, 2) > 1
    %get rid of targets that have categories outside of range of
    %label_matrix
    log = targets(:,end) > size(label_matrix, 1);
    targets(log, :) = [];
    chunks(log, :) = [];
    %get rid of chunks that have categories outside of range of
    %label_matrix
    minwidth = min([size(chunks, 2) size(label_matrix, 2)]);
    chunks = chunks(:,1:minwidth);
    un = unique(label_matrix);
    label_matrix = label_matrix(:,1:minwidth);
    grouped = cell(1, numel(un));
    for k = 1:size(targets,1)
        target = targets(k,end);
        chunk = chunks(k,:);
%         chunk = chunks(k,1:size(label_matrix,2));
        lmrow = label_matrix(target,:);
        time = chunk{1}(:,1);
        for i = 1:numel(un)
            tmp = chunk(lmrow == un(i));
            if ~isempty(tmp)
                switch datatype
                    case 'cont'
                        tmp = cellfun(@(a) a(:,end), tmp, 'un', 0);
                        tmp = horzcat(tmp{:});
                        tmp = mean(tmp,2,'omitnan');
                        grouped{1,i}{k,1} = [time tmp];
                    case 'cevent'
                        tmp = vertcat(tmp{:});
                        grouped{1,i}{k,1} = tmp;
                    case 'cstream'
                        tmp = cellfun(@(a) a(:,end), tmp, 'un', 0);
                        tmp = horzcat(tmp{:});
                        tmp = sum(tmp,2);
                        grouped{1,i}{k,1} = [time tmp];
                end
            else
                grouped{1,i}{k,1} = [];
            end
        end
    end
    chunks = horzcat(grouped{:});
%cevents
else
    log = targets(:,end) > size(label_matrix, 1);
    targets(log, :) = [];
    chunks(log, :) = [];
    for k = 1:numel(chunks)
        chunk = chunks{k};
        log = chunk(:,end) > size(label_matrix, 2);
        chunk(log, :) = [];
        fchunk = chunk;
        target = targets(k,end);
        lmrow = label_matrix(target,:);
        for l = 1:numel(lmrow)
            log = chunk(:,end) == l;
            fchunk(log,end) = lmrow(l);
        end
        chunks{k} = fchunk;
    end
end

out = chunks;

end