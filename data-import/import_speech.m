function [speech] = import_speech(date_or_sid,kid)
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


% define a list of keywords (object names) in all the studies 
% this information is obtained by going through the vocabulary list and
% find those object names 
% the order is red, blue green 
kw_exp4 = [ 8 9 6 47 46 45 72 71 70 ] ;
kw_exp5 = [ 349 348 351 368 372 373 359 360 361 ];
kw_exp6 = [ 549 551 550 554 555 539 ];
kw_exp14 = [ 555 539 554 701 550 700];  % also overlaps with exp6
kw_exp35 = [1294 716 271 945 837 1362];
kw_exp53=[2311 ]; % new ones not in the above experiments 
kw_exp41=[555 539 554 701 550 700 368 359 349 2783 372 2782]; 
%keywords = [kw_exp4 kw_exp5 kw_exp6 kw_exp14 kw_exp35 kw_exp53 kw_exp41];
kw_exp70 = [1294 716 1078 945 2713 1362 ] ; 
kw_exp71 = [549 550 554 2828 539 2783];
kw_exp72 = [368 2846  701 359 349 372] ;

exp_id = floor(date_or_sid/100)
switch exp_id
 case 71
  keywords = kw_exp71;
 case 72 
    keywords = kw_exp72;
 case 70
  keywords = kw_exp70;
 case {14, 32, 34, 36, 37, 39, 43, 44 }
  keywords = kw_exp14; 
 case 35
  keywords = kw_exp35; 
 case 41
  keywords = kw_exp41; 
 otherwise 
  keywords = kw_exp14;
end;

keywords
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

% spot object naming events
[name_event] = spot_objname(speech.uts, keywords);
% synch the time
timing = get_timing(sid);
name_event(:,1:2) = name_event(:,1:2) + timing.speechTime; 

% save the naming events

record_variable(sid, 'cevent_speech_naming', name_event);
%record_variable(sid, 'cevent_naming_event', name_event);

% speech act event and synch the timing 
%for i = 1 : size(speech.uts,2)
%    speech_act_event(i,1:2) = [speech.uts(i).bt speech.uts(i).et] + ...
%        timing.speechTime; 
%end;

% aslo record all speech act events
%record_variable(sid,'event_speech_act',speech_act_event);
