function [sequences] = cevent_query_subsequence(cevent, pattern)
% this function searches through the whole cevent and finds those
% subsequences that matches with the sequential sequences defined in 
% PATTERN
%
% Usage:
% cevent_query_subsequence(CEVENT, PATTERN)
% Input: cevent
%        PATTERN: Nx3. [minDuration category maxGap] 
%
% Output: sequences is a cell array. Each entry is a "small" cevent -- the
% subsequence that matches with the sequence query 
% 
% this functins will match a pattern defined by durations, categories, and
% gaps in a cevent variable. the output list has all the subsequences.
% e.g.
% %  cevent = [  1.7410    2.1410   64.0000
%     2.8810    4.6010   64.0000
%     5.4410    5.8210   64.0000
%     6.8010    7.3210   64.0000
%     7.4610    7.7810   64.0000
%     7.9610    8.4010   64.0000
%     9.2010    9.8810   64.0000
%    13.7610   14.0610   96.0000
%    32.7610   33.0810   32.0000
%    33.3610   34.5210   64.0000
%    34.7410   35.2210   32.0000
%    35.2410   35.6210   32.0000
%    36.1610   36.5010   32.0000
%    44.1210   44.8210   64.0000
%    55.5210   58.7610   64.0000
%    58.8410   59.5610   32.0000
%    60.7610   61.1410   32.0000
%    68.6810   69.0210   64.0000]
%    
%    case 1: pattern =  [ 0.2 64 1; 0.3 64 0];
%    output: 6 subsequences 
%     ans =
% 
%     1.7410    2.1410   64.0000
%     2.8810    4.6010   64.0000
% 
% 
% ans =
% 
%     2.8810    4.6010   64.0000
%     5.4410    5.8210   64.0000
% 
% 
% ans =
% 
%     5.4410    5.8210   64.0000
%     6.8010    7.3210   64.0000
% 
% 
% ans =
% 
%     6.8010    7.3210   64.0000
%     7.4610    7.7810   64.0000
% 
% 
% ans =
% 
%     7.4610    7.7810   64.0000
%     7.9610    8.4010   64.0000
% 
% 
% ans =
% 
%     7.9610    8.4010   64.0000
%     9.2010    9.8810   64.0000  
% 
% 
% case 2: pattern = [ 0.2 64 1.2; 0.2 32 0];   
% results: 2 subsequences 
% 
% ans =
% 
%    33.3610   34.5210   64.0000
%    34.7410   35.2210   32.0000
% 
% 
% ans =
% 
%    55.5210   58.7610   64.0000
%    58.8410   59.5610   32.0000
% 
%    case 3: pattern = [ 0.2 32 1.2; 0.2 64 0];
%     results:
%     ans =
% 
%    32.7610   33.0810   32.0000
%    33.3610   34.5210   64.0000

cp = 1; % a pointer to the current symbol in the sequence
isGap = 0; % 0 -- gap is small enough 
nSq = 0; 
nEvent = size(cevent, 1); 
nSymbol = size(pattern, 1);
sequences = []; 

i = 0; 
while (i < nEvent)
    i = i + 1; 
    if (cp > 1) 
        if ((cevent(i,1) - cevent(i-1,2))<=pattern(cp-1,3)) % check the PREVIOUS gap 
            isGap = 0;
        else
            isGap = 1; 
        end;
    end;
    if ((pattern(cp,2) == cevent(i,3)) && ((cevent(i,2) - cevent(i,1) >= pattern(cp,1))) && (isGap == 0))
        if (cp == nSymbol) % found one!
            % save it 
            nSq = nSq + 1;
            sequences{nSq} =  cevent(i-cp+1:i,:);
            i = i - cp + 1; % also set the loop back to cover overallapped patterns 
            cp = 1; % go back to the first symbol in the sequence 
            isGap = 0; 

        else
            cp = cp + 1; 
        end;
    else 
        i = i - cp + 1; % go back to recheck overlapped items 
        cp = 1; % go back to the first symbol 
        isGap = 0; 
    end;
end;

