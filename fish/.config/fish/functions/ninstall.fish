function ninstall -d "Add a Nix package to flake.nix and rebuild the system"
    set -l FLAKE_DIR "/Users/tama/dotfiles/nix/.config/nix"
    set -l FLAKE_FILE "$FLAKE_DIR/flake.nix"
    set -l HOSTNAME "Tamas-MacBook-Air"

    # Check if package name is provided
    if test (count $argv) -eq 0
        echo "Usage: ninstall <package-name>"
        echo "Example: ninstall htop"
        return 1
    end

    set -l PACKAGE_NAME $argv[1]

    # Validate package name (basic check)
    if not string match -r '^[a-zA-Z0-9_.-]+$' -- $PACKAGE_NAME >/dev/null
        echo "Error: Invalid package name. Use only letters, numbers, hyphens, dots, and underscores."
        return 1
    end

    # Check if flake.nix exists
    if not test -f $FLAKE_FILE
        echo "Error: flake.nix not found at $FLAKE_FILE"
        return 1
    end

    # Create backup
    set -l backup_file "$FLAKE_FILE.backup."(date +%Y%m%d_%H%M%S)
    cp $FLAKE_FILE $backup_file
    echo "Created backup: $backup_file"

    # Check if package already exists in the file
    if grep -q "pkgs\\.$PACKAGE_NAME" $FLAKE_FILE
        echo "Package 'pkgs.$PACKAGE_NAME' already exists in flake.nix"
        rm $backup_file
        return 0
    end

    # Find the line number where we should insert the package
    # Looking for the marker line
    set -l marker_line (grep -n "## AUTO-INSTERTED PACKAGES - DO NOT REMOVE THIS LINE ##" $FLAKE_FILE | cut -d: -f1)

    if test -z "$marker_line"
        echo "Error: Could not find insertion point in flake.nix"
        echo "Please add the package manually to the environment.systemPackages list"
        rm $backup_file
        return 1
    end

    # Insert the new package before the marker
    set -l temp_file (mktemp)
    awk -v marker_line="$marker_line" -v package="$PACKAGE_NAME" '
        NR == marker_line {
            print "          pkgs." package
        }
        { print }
    ' $FLAKE_FILE > $temp_file
    mv $temp_file $FLAKE_FILE

    echo "Added 'pkgs.$PACKAGE_NAME' to flake.nix"

    # Navigate to flake directory and rebuild
    echo "Rebuilding system..."
    set -l original_pwd (pwd)
    cd $FLAKE_DIR

    # Run darwin-rebuild
    if darwin-rebuild switch --flake ".#$HOSTNAME"
        echo "✅ Successfully installed $PACKAGE_NAME and rebuilt the system!"
        rm $backup_file
        cd $original_pwd
        return 0
    else
        echo "❌ Failed to rebuild system. Restoring backup..."
        cp $backup_file $FLAKE_FILE
        echo "Backup restored. Please check the package name and try again."
        cd $original_pwd
        return 1
    end
end
