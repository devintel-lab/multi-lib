function out = cont2scaled(IDs, varname, refactor, maxval, nbins, rgb1, rgb2)
% refactor - downsample data by this amount
%    suggested value : 5
% maxval - upper bound, represented by the darkest color
%    suggested values :
%       object size, 10
%       motion pos-speed, 150
% nbins - resolution of color space, i.e., number of distinct colors used
%    suggested value : 50
% rgb1 - color representing minimum value
%    suggested value : [1 1 1]
% rgb2 - color representing the maximum value
%    suggest value:
%       [1 0 0] for obj3
%       [0 1 0] for obj2
%       [0 0 1] for obj1
% out is a structure intended for direct input into vis_streams_multiwork function
subs = cIDs(IDs);
out.sub_list = subs;
out.data = cell(numel(subs), 1);
for s = 1:numel(subs)
    data = get_chunks(varname, subs(s));
    for d = 1:numel(data)
        %         col2o = data{d};
        if ~isempty(data{d})
            col2 = data{d}(:,2);
            col2(col2 > maxval) = maxval;
            col2 = downsample(col2, refactor);
            %         col2d = col2;
            col2 = round(col2 / maxval * nbins);
            col2(col2 == 0) = 1;
            x = (linspace(data{d}(1,1), data{d}(end,1), size(col2, 1)))';
            data{d} = [x, col2];
            %         plot(col2o(:,1), col2o(:,2));
            %         hold on;
            %         plot(x, col2d, 'color', 'green');
        end
    end
    out.data{s,1} = data;
end
log = cellfun(@(a) all(isempty(a)), out.data);
out.sub_list(log) = [];
out.data(log) = [];
out.colors = gradcolormap(rgb1, rgb2, nbins);
out.edge = 0;
end
