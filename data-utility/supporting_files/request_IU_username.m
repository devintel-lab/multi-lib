function request_IU_username()

if isempty(getenv('IU_username'))
    IU_username = input('enter IU username: ', 's');
    setenv('IU_username', IU_username);
end

end