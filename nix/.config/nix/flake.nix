{
  description = "Very Zenful System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, home-manager, ... }:
  let
    configuration = { pkgs, config, ... }: {

      # Allow mac app store and proprietary apps
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
          pkgs.vim
          pkgs.neovim
          pkgs.wezterm
          pkgs.fish
          pkgs.bat
          pkgs.fzf
          pkgs.git
          pkgs.jq
          pkgs.lazygit
          pkgs.lua
          pkgs.tmux
          pkgs.yabai
          pkgs.obsidian
          pkgs.arc-browser
          pkgs.home-manager
          pkgs.ripgrep
          pkgs.youtube-music
        ];

        homebrew = {
          enable = true;

          # CLI Tools
          brews = [
            "neofetch"
          ];

          # GUI Apps
          casks = [
            "wezterm"
            "youtube-music"
          ];
      };


      # Allow touchID for sudo auth
      security.pam.enableSudoTouchIdAuth = true;

      environment.etc = {
        "pam.d/sudo_local".text = ''
        auth sufficient pam_tid.so
        '';
      };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Set fish to default shell
      users.users.tama.shell = pkgs.fish;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;


      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";


      # Home Manager
      users.users.tama.home = "/Users/tama/";
      # home-manager.backupFileExtension = ".bak";

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Tamas-Laptop
    darwinConfigurations."Tamas-Laptop" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "tama";
              autoMigrate = true;

              # # Optional: Declarative tap management
              # taps = {
              #   "homebrew/homebrew-core" = homebrew-core;
              #   "homebrew/homebrew-cask" = homebrew-cask;
              #   "homebrew/homebrew-bundle" = homebrew-bundle;
              # };

            };
          }
        ];
    };

    # Expose the package set, for convenience
    darwinPackages = self.darwinConfigurations."Tamas-Laptop".pkgs;
  };
}
