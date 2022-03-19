# dots
My dotfiles.

## Installation

Symlink all the files in src/ to your home directory using the provided dotinstall.sh script, or manually.
Otherwise, copy them manually to your home directory.

After, install the programs that I have dots for. A list is provided in the programs file.

You should install [my dwm](https://github.com/dogeystamp/dwm), [dmenu](https://github.com/dogeystamp/dmenu), [slock](https://github.com/dogeystamp/slock) and [st](https://github.com/dogeystamp/st) builds as well as this for a complete desktop environment.

### Notes

The xinitrc provides changes I like, such as swapping escape and caps lock, which you should remove if you don't need.

Also, by default, picom is disabled, due to performance issues, however, it is already configured to blur and fade windows.
If you wish to turn it on, uncomment its line in `src/.xinitrc`.

My qutebrowser configuration emphasizes privacy over usability, and you might need to edit it to suit your needs if you want to use it.

**Desktop Preview**

With Picom on
![preview](https://raw.githubusercontent.com/DogeyStamp/dots/main/preview.png)

With Picom off
![preview](https://raw.githubusercontent.com/DogeyStamp/dots/main/preview2.png)
