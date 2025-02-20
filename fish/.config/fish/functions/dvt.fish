function dvt --description 'creates a new flake template for direnv'
    nix flake init -t "github:the-nix-way/dev-templates#$argv[1]"
    direnv allow
end
