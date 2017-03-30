function [data, infoidx, n] = parse_yarbus(filename)

fid = fopen(filename, 'rb');

line = fgetl(fid);
n = 1;

while isempty(strfind(line, 'scene resolution:'))
    line = fgetl(fid);
    n = n + 1;
end

res = sscanf(line, 'eye resolution: %dx%d scene resolution: %dx%d');

infoidx.eyeResolution = [res(1) res(2)];
infoidx.sceneResolution = [res(3) res(4)];

while isempty(strfind(line, 'recordFrameCount'))
    line = fgetl(fid);
    n = n + 1;
end

delim = strsplit(line, ' ');
for d = 1:numel(delim)
    switch delim{d}
        case 'recordFrameCount'
            infoidx.frameCount = d;
        case 'porX'
            infoidx.porX = d;
        case 'porY'
            infoidx.porY = d;
    end
end

% skip additional blank lines
while isempty(fgetl(fid))
    n = n + 1;
end
fclose(fid);

data = scantext(filename, ' ', n);
end