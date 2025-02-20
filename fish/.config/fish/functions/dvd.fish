function dvd --description 'creates and activates a new direnv in the current directory'
    echo "use flake \"github:the-nix-way/dev-templates?dir=$argv[1]\"" >> .envrc
    direnv allow
end
