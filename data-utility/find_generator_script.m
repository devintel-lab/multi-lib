function find_generator_script(var_name)


subjects = find_subjects({var_name});

for S = 1:numel(subjects)
    subject = subjects(S);
    
    info = var_info(subject, var_name);
    if ~ isempty(info)
        fprintf('Found origin for %s in subject %d\n', var_name, subject);
        
        % print "run by billybobjoe on bigserver" (if all that info is
        % available)
        fprintf('Scripts run by %s', info.user);
        if isfield(info, 'hostname')
            fprintf(' on %s\n', info.hostname);
        else
            fprintf('\n');
        end
        
        % print the stack
        disp(format_stack(info.stack));
        fprintf('\n\n');
    end
end




function stack_str = format_stack(stack)
stack_str = '';
for I = 1:numel(stack)
    arrow = ' --> ';
    is_last_time = I == numel(stack);
    if is_last_time
        arrow = '';
    end
    
    
    stack_str = [stack_str ...
        sprintf('%s:%d', stack(I).file, stack(I).line)  arrow];
end

