function out = dyn_field(structure, fieldnames)
% returns contents of nested structure fields using dynamic field names
        fnames = strsplit(fieldnames, '.');
        if numel(fnames) == 1
            out = structure.(fnames{1});
        else
            part_structure = structure.(fnames{1});
            new_fnames = strjoin(fnames(2:end), '.');
            out = dyn_field(part_structure, new_fnames);
        end
end