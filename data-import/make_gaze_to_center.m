function make_gaze_to_center(subexpID, corp)
%finds the centroid of  a cluster of gaze data points, and then calcuates
%the distance from that center to each data point.
%subexpID can be a subject list for experiment list
%corp is [1 2] or [1] or [2] where 1 is child and 2 is parent
%maxx is x resolution, default is 720
%maxy is y resolution, default is 480

person = {'child' 'parent'};

if numel(num2str(subexpID(1))) > 2
    subs = subexpID;
elseif numel(num2str(subexpID(1))) == 2
    subs = list_subjects(subexpID);
end

%uncommenting these will override any subexpID input
%subs = [3201 3203 3204 3205 3206 3207 3208 3210 3211 3212 3213 ...
%            3214 3215 3216 3217 3218]'; % 32 child 
%subs = [3201 3203 3204 3205 3206 3207 3208 3210 3212 3213 ...
%           3214 3215 3216 3218]; % 32 parent 
%subs = [3403 3404 3405  3409 3410 3413 ...
%            3414 3415 3416 3417]'; % 34 child 
% subs = [3401 3402 3404 3406 3407 3408 3409 3410 3413 ...
%             3414 3415 3416 3417 3418]'; % 34 parent 
                                        %sub_list = 3402;

for s = 1:numel(subs)
    for p = 1:numel(corp)
        personID = person{corp(p)};
        if has_variable(subs(s), ['cont_eye_x_' personID]);
            chunks_x = get_variable_by_trial(subs(s), ['cont_eye_x_' personID]);
            chunks_y = get_variable_by_trial(subs(s), ['cont_eye_y_' personID]);
            
            new_data = [];
            if ~isempty(chunks_x) && ~isempty(chunks_y)
                cont_x =  cat(1, chunks_x{:});
                cont_y =  cat(1, chunks_y{:});
                new_data(:,1) = cont_x(:,1);
                
                center_x = nanmedian(cont_x);
                center_y = nanmedian(cont_y);
%                 [center_x(:,2) center_y(:,2)]
                data = [cont_x(:,2) cont_y(:,2)];
                new_data(:,2) = distances(data, [center_x(:,2) center_y(:,2)]);
%                 size(new_data);
%                 nanmedian(new_data(:,2));
                
                % generate a new variable
                file_name = sprintf('cont_eye_dist-to-center_%s', personID);
                record_variable(subs(s),file_name,new_data);
            end
        else
            fprintf('Subject %d did not have the "cont_eye_x_%s" variable\n', subs(s), personID)
        end
    end
end

end