# dots

My dotfiles.

## Installation

Symlink all the files in src/ to your home directory using the provided dotinstall.sh script, or manually.
Otherwise, copy them manually to your home directory.

After, install some packages. A list is provided in the `programs` file.
This list encompasses all packages needed for a full system, including utilities and games.
Feel free to pick and choose which packages you want.
A script is also provided with `programs-python` to install Python packages via pipx.
Package availability and their names **differ based on the distribution**: these are for Arch Linux and its derivatives.

For a full desktop experience,
you should also build the programs in `suckless/` by running `./compile-suckless.sh` as root.
Alternatively, build the programs with the README instructions in the directory.

Some features are enabled or disabled based on a "system profile":
once the dotfiles are installed, see `~/.config/dot_profile.example` for more information.

### Notes

`.local/bin/keyboard.sh` provides changes I like, such as swapping escape and caps lock, which you should remove if you don't need.

My qutebrowser configuration emphasizes privacy over usability, and you might need to edit it to suit your needs if you want to use it.

**Desktop Preview**

![preview](https://raw.githubusercontent.com/DogeyStamp/dots/main/preview.png)

![preview](https://raw.githubusercontent.com/DogeyStamp/dots/main/preview2.png)
