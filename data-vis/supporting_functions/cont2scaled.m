function out = cont2scaled(subid, varname, refactor, maxval, nbins, rgb1, rgb2)
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

out = [];
if has_variable(subid, varname)
    data = get_variable(subid, varname);
    col2 = data(:,2);
    col2(col2 > maxval) = maxval;
    col2 = downsample(col2, refactor);

    col2 = round(col2 / maxval * nbins);
    col2(col2 == 0) = 1;
    x = (linspace(data(1,1), data(end,1), size(col2, 1)))';
    data = [x, col2];
%     data = cstream2cevent(data);

    colors = gradcolormap(rgb1, rgb2, nbins);
    out.data = data;
    out.args.draw_edge = 0;
    out.args.colors = colors;
    out.args.isCont = 1;
end
end
