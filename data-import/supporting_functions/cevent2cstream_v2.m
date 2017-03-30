function base = cevent2cstream_v2(cevent, sample_rate, time_period, time_base)

if ~exist('time_base', 'var')
    %define shorthand
    sr = sample_rate;
    tp = time_period;
    
    %turn events into cevent with category 1
    
    if size(cevent, 2) == 2
        cevent(:,3) = 1;
    end
    
    %subtract sample rate from 2nd column
    cevent(:,2) = cevent(:,2) - sample_rate;
    
    %make sure cevent data is in order
    cevent = sortrows(cevent, [1 2]);
    
    %establish time base series with given sample rate and start end time
    base = tp(1):sr:tp(end);
    base = base';
    
    %time_base input overrides above base
else
    base = time_base;
    tp = [base(1) base(end)];
%     sr = mode(diff(base)); %can use this to exclude cevents that fall outside of trial range
end

base = [base zeros(numel(base),1)];

if ~isempty(cevent)
    for c = 1:size(cevent,1)
        if (cevent(c,2) >= tp(1) || tp(1) - cevent(c,2) < 0.0001) && (cevent(c,1) <= tp(2) || cevent(c,1) - tp(2) < 0.0001) %makes sure whole cevent fits into time-base range;
            %also this partially captures cevents that are cut off by tp(1) and tp(2);
            [~, i] = min(abs(base - cevent(c,1)));
            [~, i2] = min(abs(base - cevent(c,2)));
            check = base(i:i2,2);
            if sum(check) > 0
                fprintf('overlap detected: %d\n', sum(check>0));
                disp(cevent(c,:));
            end
            base(i:i2,2) = cevent(c,3);
        end
    end
else
    base = base(:,1);
end

end