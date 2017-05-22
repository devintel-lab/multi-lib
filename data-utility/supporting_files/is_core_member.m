function is_auth = is_core_member(IU_username)

authorized_members = scantext(fullfile(get_multidir_root(), 'core_member_list.txt'), '', 0, '%s');
authorized_members = authorized_members{1};

is_auth = ismember(IU_username, authorized_members);
end