if status is-interactive
    zoxide init fish | source
    starship init fish | source
    thefuck --alias | source
end
