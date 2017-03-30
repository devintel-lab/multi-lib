function [events stats] = spot_objname(speech, words)
% find the object naming events in a speech transcription
%  ignore the "stats" part for now 
%

events = zeros(0, 3);
nsit = size(speech,2);
nevent = 0; 

% count the # of object names 
stats.freq = zeros(size(words));
stats.cooccur = zeros(size(words));
stats.alone = zeros(size(words));
stats.aloneP = zeros(size(words));

for i = 1 : nsit
    nword = size(speech(i).words,2);
    
    for j = 1 : nword
        
        % this is an object name
        if (ismember(speech(i).words(j), words) == 1)
            
            % record the event
            nevent = nevent + 1;
            events(nevent,1) = speech(i).bt;
            events(nevent,2) = speech(i).et;
            events(nevent,3) = speech(i).words(j);
            
            % calculate the stats
            index = find(words == speech(i).words(j));
            stats.freq(index) = stats.freq(index) + 1;
            
            stats.cooccur(index) = stats.cooccur(index) + size(speech(i).words,2);
            if (size(speech(i).words,2) == 1)
                stats.alone(index) = stats.alone(index) + 1; 
            end;
        end;
    end;
end;

% per occurrence 
stats.cooccur = stats.cooccur ./ stats.freq;
stats.aloneP = stats.alone ./stats.freq; 


