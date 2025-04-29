function ssh-me
    eval $(ssh-agent -c)
    ssh-add
end
