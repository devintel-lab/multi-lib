function out = gradcolormap(rgb1, rgb2, n, flag_showcolormap)
out = zeros(n,3);
for i = 1:n
    out(i,:) = rgb2*(i-1)/(n-1) + rgb1*(1-(i-1)/(n-1));
end
if exist('flag_showcolormap', 'var') && ~isempty(flag_showcolormap) && flag_showcolormap
    figure;
    colormap(out);
    colorbar;
end
end