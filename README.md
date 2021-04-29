# dots
My dotfiles.

## Installation

Copy all the folders in here (including hidden ones like .config) to your home directory.
You don't need .git, and you probably don't need my scripts in .local/bin (like mon-on or notification-sound.sh).

After, install the programs that I have dots for (you can remove the ones you don't use):

`pacman -S - < programs`

Then install the AUR programs in programs-aur using your preferred method.

You should install [my dwm](https://github.com/dogeystamp/dwm), [dmenu](https://github.com/dogeystamp/dmenu), [slock](https://github.com/dogeystamp/slock) and [st](https://github.com/dogeystamp/st) builds as well as this for a complete desktop environment.

### Note

The xinitrc provides changes I like, such as swapping escape and caps lock, which you should remove if you don't need.
Also, the aesthetic is very minimal, so consider adding a wallpaper. Picom is already configured for blur/fading, but you should disable it if you wish to keep the black wallpaper.

**Desktop Preview**
![preview](https://raw.githubusercontent.com/DogeyStamp/dots/main/preview.png)
