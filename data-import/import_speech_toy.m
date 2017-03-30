function [speech] = import_speech_toy(date_or_sid,kid)
% translate a speech transcription into two matlab-based formats
%   import_speech(DATE, KID_ID)
%       Import the speech transcription found in the directory of the
%       experiment with the given KID on the given DATE.  The DATE is given
%       in the usual format: a number like 20080424, YYYYMMDD.
%
%   import_speech(SUBJECT_ID)
%       Import the speech transcription found in the given subject's
%       directory.
%
%   This function generates two files, the object naming event file used by
%   the visualization program (cevent_naming_event.mat), and a
%   speech_transcription file (speech_trans.mat) which is more useful to
%   MATLAB users.  Both are generated in the derived/ subdirectory of the
%   subject dir.


if nargin == 1
    % the arg is just the subject ID.
    sid = date_or_sid;
    info = get_subject_info(sid);
    kid = info(4);
elseif nargin == 2
    % find the subject id based on data and kid id
    subjects = read_subject_table(); 
    index = intersect(find((subjects(:,3) == date_or_sid)), find(subjects(:,4) == kid));
    if (isempty(index) == 1)
      disp('wrong subject information\n');
      return; 
    else
      sid = subjects(index,1); 
    end;
else
    % wrong usage
    disp('invalid arguments\n');
    return;
end

% find the speech transcription file
fname = sprintf('%s/speech_transcription_p/speech_%d_out.txt', ...
		get_subject_dir(sid),kid)

    
%  
% data structure: speech.uts: an array of spoken utterances, with bt, et
% and words
% speech.stats: some statistical measures
% 
% load the file and save it
speech.uts = load_speech(fname);
speech.stats = cal_word_stats(speech.uts);
fname = sprintf('%s/derived/speech_trans.mat', get_subject_dir(sid));
save(fname, 'speech'); 

% load naming events '


fname = sprintf('%s/speech_transcription_p/naming_instances.csv', ...
		get_subject_dir(sid)) 
[name_event] = csvread(fname);
% synch the time
timing = get_timing(sid);
name_event(:,1:2) = name_event(:,1:2) + timing.speechTime; 

% save the naming events
record_variable(sid, 'cevent_speech_naming_local-id', name_event);

% generate speech utterance variable
sdata = get_variable(sid, 'speech_trans');
bt = (arrayfun(@(a) a.bt, sdata.speech.uts))';
et = (arrayfun(@(a) a.et, sdata.speech.uts))';

non_referent_id = 25; 
utterance = [bt + timing.speechTime et+timing.speechTime ones(size(bt,1),1)*non_referent_id];

for i = 1: size(utterance,1)
  index=  find(utterance(i,1) == name_event(:,1)); 
  if ~isempty(index)
    if size(index,1) == 1
      utterance(i,3) = name_event(index,3);
    else % more than one names 
      utterance(i,3) = name_event(index(1),3);
    end;
  end;
end;

record_variable(sid, 'cevent_speech_utterance', utterance);
