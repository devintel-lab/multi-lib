function new_cstream = fix_cstream(cstream, filler)
   % This is a function for fixing cstream that has gaps in it and fill them with number so that we have a full stream
   % Assume that the range is evenly spaced
   % Compute total range
   
   step = cstream(2,1) - cstream(1,1);
   new_cstream = zeros(round((cstream(end,1) - cstream(1,1))/step + 1),2);
   %cstream(end,1) - cstream(1,1))/step + 1
   % length(new_cstream)

   % Fill in range
   for i=1:length(new_cstream)
      new_cstream(i,1) = cstream(1,1) + (i-1) * step;
   end

   %[new_cstream(1,1) cstream(1,1) new_cstream(end,1) cstream(end,1)]
   % new stream index
   j = 0;
   % Move along old stream
   for i = 1:length(cstream)
      j = j + 1;
      while(abs(cstream(i,1) - new_cstream(j,1)) > step/4)
         %[i j cstream(i,1) new_cstream(j,1)]
         % Find hole just add filler and move on
         new_cstream(j,2) = filler;
         j = j +1;
      end
      % copy the value
      new_cstream(j,2) = cstream(i,2);

   end
end