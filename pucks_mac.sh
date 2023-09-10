#!/bin/sh

# Welcome to a fork of the thoughtbot laptop script!
# Be prepared to turn your laptop (or desktop, no haters here)
# into an awesome development machine.

# this just currently remaps the § to # which is pretty much the first thing I do on every mac
# also kept the global ignore for .DS_Store files which feels potentially handy and potentially a timebomb.

# before running or if the keybinding fails because permission is denied, make sure your user is on the users list
# for the new keybinding folder and that you have full permisisons. 

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

create_folder_if_not_there() {
  local folder="$1"

  if [ -d "$folder" ]; then
    if ! [ -r "$folder" ]; then
      sudo chown -R "$LOGNAME:admin" "$folder"
    fi
  else
    sudo mkdir -p "$folder"
    sudo chflags norestricted "$folder"
    sudo chown -R "$LOGNAME:admin" "$folder"
  fi
}

fancy_echo "Rebinding # to the § key"
create_folder_if_not_there "$HOME/Library/KeyBindings"
MACOS_KEYMAP_FILE="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
touch "$MACOS_KEYMAP_FILE"
cat > "$MACOS_KEYMAP_FILE" << EOM
{
  /* Map '#' to the § key */
  "§" = ("insertText:", "#");
}
EOM

fancy_echo "Globally ignoring .DS_Store files"
echo .DS_Store >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
git config --global init.defaultBranch main
