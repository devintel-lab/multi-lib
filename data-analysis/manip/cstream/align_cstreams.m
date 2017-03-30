function varargout = align_cstreams(varargin)

varargout = cell(1,numel(varargin));
for c = 1:numel(varargin)
    if c > 1
        if size(varargin{c},2) == 2
            cev = cstream2cevent(varargin{c});
        else
            cev = varargin{c};
        end
        varargout{1,c} = cevent2cstreamtb(cev, varargin{1}(:,1));
    else
        varargout{1,c} = varargin{c};
    end
end

end