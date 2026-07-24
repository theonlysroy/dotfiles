#!/usr/bin/env bash

THEMES_DIR="$HOME/.themes"
GTK4_CONFIG="$HOME/.config/gtk-4.0"
CONFIG_DIR="$HOME/.config"

# ------------------------------ ------------------------------
#  ------------------------------Collect themes
# ------------------------------ ------------------------------

themes=()

for dir in "$THEMES_DIR"/*; do
    [ -d "$dir" ] && themes+=("$(basename "$dir")")
done

# ------------------------------ ------------------------------
#  ------------------------------Check themes exist
# ------------------------------ ------------------------------

if [ ${#themes[@]} -eq 0 ]; then
    echo "No themes found in $THEMES_DIR"
    exit 1
fi

# ------------------------------ ------------------------------
# ------------------------------ Theme selection
# ------------------------------ ------------------------------

echo "Available themes:"
for i in "${!themes[@]}"; do
    echo "$((i+1)). ${themes[$i]}"
done

echo
read -p "Choose a theme number: " choice

THEME="${themes[$((choice-1))]}"

if [ -z "$THEME" ]; then
    echo "Invalid selection"
    exit 1
fi

THEME_PATH="$THEMES_DIR/$THEME"

# ------------------------------ ------------------------------
# ------------------------------ Asset location selection
# ------------------------------ ------------------------------

echo
echo "Where is the assets folder located?"
echo "1. Inside gtk-4.0/assets"
echo "2. Directly inside theme/assets"

read -p "Choose option (1/2): " ASSET_LOCATION

# ------------------------------ ------------------------------
# ------------------------------ Determine asset path
# ------------------------------ ------------------------------

if [ "$ASSET_LOCATION" = "1" ]; then
    ASSETS_SOURCE="$THEME_PATH/gtk-4.0/assets"
elif [ "$ASSET_LOCATION" = "2" ]; then
    ASSETS_SOURCE="$THEME_PATH/assets"
else
    echo "Invalid option"
    exit 1
fi

# ------------------------------ ------------------------------
# ------------------------------ Ask where to symlink assets
# ------------------------------ ------------------------------

echo
read -p "Symlink assets directly to ~/.config/assets ? (y/n): " DIRECT_ASSETS

echo
echo "Applying theme: $THEME"

# ------------------------------ ------------------------------
# ------------------------------ GTK4 Setup
# ------------------------------ ------------------------------

if [ -d "$THEME_PATH/gtk-4.0" ]; then

    rm -rf "$GTK4_CONFIG"
    mkdir -p "$GTK4_CONFIG"
    # rm "$GTK4_CONFIG/gtk.css" "$GTK4_CONFIG/gtk-dark.css"

    # ------------------------------
    # Handle assets
    # ------------------------------

    if [ -d "$ASSETS_SOURCE" ]; then

        if [[ "$DIRECT_ASSETS" =~ ^[Yy]$ ]]; then

            rm -rf "$CONFIG_DIR/assets"

            ln -s \
                "$ASSETS_SOURCE" \
                "$CONFIG_DIR/assets"

            echo "Assets linked to $CONFIG_DIR/assets"

        else

            ln -s \
                "$ASSETS_SOURCE" \
                "$GTK4_CONFIG/assets"

            echo "Assets linked to $GTK4_CONFIG/assets"

        fi

    else

        echo "Assets folder not found"

    fi

    #------------------------------
    # GTK CSS
    #------------------------------

    if [ -f "$THEME_PATH/gtk-4.0/gtk.css" ]; then

        ln -s \
            "$THEME_PATH/gtk-4.0/gtk.css" \
            "$GTK4_CONFIG/gtk.css"

        echo "gtk.css linked"

    else

        echo "gtk.css not found"

    fi

    #------------------------------
    # GTK Dark CSS
    #------------------------------

    if [ -f "$THEME_PATH/gtk-4.0/gtk-dark.css" ]; then

        ln -s \
            "$THEME_PATH/gtk-4.0/gtk-dark.css" \
            "$GTK4_CONFIG/gtk-dark.css"

        echo "gtk-dark.css linked"

    else

        echo "gtk-dark.css not found"

    fi

    echo "GTK4 applied"

else

    echo "gtk-4.0 directory not found"

fi

# ------------------------------ ------------------------------ 
# ------------------------------ GTK3 Theme
# ------------------------------ ------------------------------

gsettings set org.gnome.desktop.interface gtk-theme "$THEME"

# ------------------------------ ------------------------------
# ------------------------------ GNOME Shell Theme
# ------------------------------ ------------------------------

# if [ -d "$THEME_PATH/gnome-shell" ]; then
# 
#     gsettings set \
#         org.gnome.shell.extensions.user-theme \
#         name "$THEME"
# 
#     echo "Shell theme applied"
# 
# else
# 
#     echo "No GNOME Shell theme found"
# 
# fi

echo
echo "Done."
