function main_make_inhand(IDs, obj_list)
%% Function to make all the main inhand variables for any experiment:
% Inhand Variables Documentation:
% 
% events:  Total number = 2(hands) X 2 (subject) X the 3(number of objects) 
% per trial, for 3 objects, then we would have 12 events.  For 5 object 
% experiments, we would have 20 events.
% event_inhand_[left/right]_obj[#]_[parent/child]
%
% sbf: no longer using event-based inhand as of exp 39, 5/2013
% 
% 
% cevents: Total number = 2(number of subjects with inhand data).  Events 
% can overlap within the cevent.  The categorical value is equal to the 
% object id that is held.  So, if a subject is holding object 1 between 
% 5-15 seconds in the left hand, object 2 between 10-20 seconds in the 
% right hand, and object 3 between 18-25 seconds in the left hand, you 
% would have the following cevent:
% 5	15	1
% 10	20	2
% 18	25	3
% cevent_inhand_[child/parent]
% 
% 
% cstreams:  Total number = 2(subjects) X the number of objects per trial, 
% for 3 objects, then we would have 6 cstreams and for 5 objects we would 
% have 10 cstreams.  The categorical values are:   1 = left hand, 
% 2 = right hand, 3 = both hands.
% cstream_inhand_obj[#]_[parent/child]
% 
% 
% Total number of inhand variables = 20 for 3 objects per trial experiments.

% -------------------------------------------------------------------
% You need to set the following things per experiment:
subs = cIDs(IDs);
participant_list = {'child' 'parent'};

if ~exist('obj_list', 'var') || isempty(obj_list)
    inhand_list ={'obj1','obj2','obj3'};
else
    inhand_list = cell(numel(obj_list));
    for o = obj_list
        inhand_list{o} = sprintf('obj%d',o);
    end
end

hand_type = {'left','right'};

% and either run this on every subject or select specific subjects:
subj_list = subs;

% -------------------------------------------------------------------

% Go through each subject.
for s = 1 : length(subj_list)
    
    subj = subj_list(s);
    
    % Go through each participant
    for p = 1 : length(participant_list)
    
        participant = participant_list{p};
        
        % Check to see if they have the inhand coding done.
        if has_variable(subj, sprintf('cstream_inhand_%s-hand_%s_%s', ...
                hand_type{1}, inhand_list{1}, participant))
            
            % A temporary holder of the cstream data per hand, col1=left
            % hand, col2 = right hand data.
            hand_data = [];
            
            % Data for each object
            output=[];
            left_right_data = {};
            % loop through the objects
            for o = 1 : size(inhand_list,2)
                
                object = inhand_list{o};
                
                % create data for cevents
                cev_hand_data{o} = [];
                
                % loop through both hands
                for h = 1 : size(hand_type,2)
                    
                    % Grab the cstream variable.
                    temp_cstream = get_variable(subj, sprintf('cstream_inhand_%s-hand_%s_%s', ...
                        hand_type{h}, object, participant));
                    
                    left_right_data{h,1}(:,o) = temp_cstream(:,2); 
                    
                    hand_data(:,h) = temp_cstream(:,2);
                    
                    % Turn left hand into 1's, and right hand into 2's.  When 
                    % we sum across we will have 1=left, 2=right, 3=both.
                    hand_data(hand_data(:,h) > 0, h) = h;
                    left_right_data{h,1}(temp_cstream(:,2) > 0,o) = o; 
                    
                    % Grab the event data to create the cevents later.
                    temp_event = cstream2cevent(temp_cstream);
%                     
%                     % Turn the event into a cevent with the object id
%                     temp_event(:,3) = o;
%                     
                    cev_hand_data{o} = [cev_hand_data{o};temp_event];
                    
                end;
                
                % Set the cstream times:
                output(:,1) = temp_cstream(:,1); 
                % Set the cstream value to the sum of hand data.
                output(:,2) = sum(hand_data,2);

                % Record the cstream_inhand_obj#_[participant]
                output(:,2) = output(:,2) > 0; %changes 1 2 and 3 into just 1
                record_variable(subj, sprintf('cstream_inhand_%s_%s', object, participant), output);
                          
            end;
            
            for h = 1:2
                left_right = left_right_data{h,1};
                left_right = sum(left_right, 2);
                left_right = cat(2, output(:,1), left_right);
                record_variable(subj, sprintf('cstream_inhand_%s-hand_obj-all_%s', hand_type{h}, participant), left_right);
            end
            
            % Now create the cevent_inhand_[participant]
            % Combine all the object events and sort the rows.
            cev_inhand = sortrows(vertcat(cev_hand_data{:}), [1 2]);
            
            % Record the cevent
            record_variable(subj, sprintf('cevent_inhand_%s', participant), cev_inhand);
            
        end;
        
    end;
         
end;




