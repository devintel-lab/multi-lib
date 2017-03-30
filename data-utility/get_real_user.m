function user = get_real_user()
% Finds the user who's "really" running matlab: the one who su'd to the
% matlab user.
this_pid = getpid();
this_user = get_user(this_pid);

% initialize to the matlab process's pid and user
parent_pid = this_pid;
parent_user = this_user;

% each time through the loop finds the pid and user of the next ancestor
while strcmp(this_user, parent_user)
    parent_pid = get_ppid(parent_pid);
    parent_user = get_user(parent_pid);
    
    % prevent an infinite loop (on Unix if you're running Matlab as root
    % for some reason)
    if parent_pid == 1
        parent_user = 'root';
        break
    end
end

user = parent_user;


function ppid = get_ppid(pid)
[err, ppid_str] = system(sprintf('ps -p %d -o ppid=', pid));
if err
    error('ps returned error');
end

ppid = sscanf(ppid_str, '%d');

function user = get_user(pid)
[err, user_str] = system(sprintf('ps -p %d -o user=', pid));
if err
    error('ps returned error');
end
user = strtrim(user_str);
