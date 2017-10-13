function indices = suitTimeStamps(timeData, formatted)
indices = zeros(numel(formatted), 1);
counter = 1;
for i = 1:numel(formatted)
    tmpCounter = counter;
    while formatted(i) > timeData(tmpCounter)
        tmpCounter = tmpCounter + 1;
        if tmpCounter > numel(timeData)
            if abs(formatted(i) - timeData(tmpCounter -1)) < 0.16
                indices(i) = tmpCounter - 1;
            else
                indices(i) = NaN;
            end
            tmpCounter = NaN;
            indices(i + 1 : end) = NaN;
            break
        end
    end
    if isnan(tmpCounter)
        break
    end
    if timeData(tmpCounter) == formatted(i)
        indices(i) = tmpCounter;
        counter = tmpCounter;
    else
        tc1 = abs(timeData(tmpCounter) - formatted(i));
        tc2 = abs(timeData(tmpCounter - 1) - formatted(i));
        if tc1 > tc2 
            indices(i) = tmpCounter - 1;
            counter = tmpCounter;
        else
            indices(i) = tmpCounter;
            counter = tmpCounter;
        end
    end
end
end
