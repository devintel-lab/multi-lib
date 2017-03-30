function make_eye_roi(IDs, obj_list)
% convert individual coding stream into one
subs = cIDs(IDs);

if ~exist('obj_list', 'var') || isempty(obj_list)
    roi_list = {'obj1','obj2','obj3','head'};
else
    roi_list = [];
    for r = obj_list;
        roi_list{r} = sprintf('obj%d',r);
    end
    roi_list = cat(2, roi_list, 'head');
end

prefix = 'cstream_eye_roi';
agent = {'child' 'parent'};

for i = 1 : numel(subs)
    for a = 1:2
        suffix = agent{a};
        if has_variable(subs(i),sprintf('%s_%s_%s',prefix, roi_list{1}, suffix))
            data = [];output=[];
            for j = 1 : size(roi_list,2)
                temp = get_variable(subs(i), sprintf('%s_%s_%s',prefix, ...
                    roi_list{j}, suffix));
                data(:,j) = temp(:,2);
            end;
            
            output(:,2) = sum(data,2);
            output(:,1) = temp(:,1);
            record_variable(subs(i), sprintf('%s_%s',prefix,suffix),output);
            
            cevent_data = cstream2cevent(output);
            record_variable(subs(i), sprintf('cevent_eye_roi_%s',suffix),cevent_data);
            
        end;
    end
end;

