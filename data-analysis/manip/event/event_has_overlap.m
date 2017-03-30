function has_overlap = event_has_overlap(evt_list, query)
has_overlap = false(size(evt_list, 1), 1);
for I = 1:size(evt_list, 1)
    has_overlap(I) = ...
        ~ isempty( event_AND( evt_list(I,:), query ) );
end


end