function [speech] = load_speech(fname)
% load the speech transcription file into a matlab structure 
%  input: a transcription file name
%  output: matlab data structure 
%  
  

fp = fopen(fname);

nsen = 1; % the # of spoken utterances 


while 1
  tline = fgetl(fp);
  if ~ischar(tline), break,end
  if (size(tline,2) > 1) 
    a = sscanf(tline,'%f');
    
    % the first two are bt and et timestamps
    speech(nsen).bt = a(1);
    speech(nsen).et = a(2);
    % the following items are words 
    speech(nsen).words = a(3:end)';
    nsen = nsen + 1; 
  end;
end;



