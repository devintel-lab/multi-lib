% ts = event2timeseries(event) 
% This function converts an event coding to time series
% Event is assumed to be coded by start stop time in each row.
% so event variable is expected to be n x 2 array\
% ts output will make sure that if the time is in (start,stop]
% the value is 1, otherwise the value is 0
% see https://einstein.psych.indiana.edu/pmwiki/index.php/Main/SynchronizeTimeDataInMATLAB for how to use

function ts = event2timeseries(event)
    % Create values
    v = cat(2,ones(size(event(:))));
    ts = timeseries(v,event(:));
    handle = @(new_Time,Time,Data)...
        stepInterpolation(new_Time,Time,Data);
    % Change interpolation method to our step function
    ts = setinterpmethod(ts,handle);
end

% This function create an interpolation for event time when things are
% either 0 or 1
function v = stepInterpolation(new_Time,Time,Data)
    v = 1;
    if(exist('new_Time','var') && exist('Time','var') && exist('Data','var'))
        v = zeros(length(new_Time),1);

        endOfTime = length(Time);

        % check if new time is on the left of events
        if(Time(1) > new_Time(end))
            return
        end

        % find the closest time point
        p = binary_search_asc(Time,new_Time(1)); 
        % Verify time point
        if(Time(p) < new_Time(1))
            % The time is on the right of our event code so dump all 0
            return
        else
            % must find something so lets iterate through this

            % Setup filling value 1 for coming even position
            cv = ~mod(p,2);

            % Loop from first new time to last new time
            total = length(new_Time);
            for i = 1:total
                t = new_Time(i);
                ct = Time(p);
                % Move the time boundary if it is exceeded
                if( t > ct)
                    while(t > ct)
                        p = p+1;

                        % Stop when the position exceed the end
                        if(p > endOfTime)
                            return
                        end

                        ct = Time(p);
                    end

                    % Change filling value
                    cv = ~mod(p,2);
                end


                % check if the time hit the boundary
                if(t == ct)
                    % set value to 1
                    v(i) = 1;
                else
                    % set value according to the filler
                    v(i) = cv;
                end
            end
        end 
    end
end
