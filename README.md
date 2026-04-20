# dots

My dotfiles.

## Installation

Install [chezmoi](https://chezmoi.io):

```
# pacman -S chezmoi
```

Clone then apply these dotfiles:

```
chezmoi init dogeystamp/dotfiles --apply
```

After, install some packages. A list is provided in the `programs` file.
This list encompasses all packages needed for a full system, including utilities and games.
Feel free to pick and choose which packages you want.
Package availability and their names **differ based on the distribution**: these are for Arch Linux and its derivatives.

Some features are enabled or disabled based on a "system profile":
chezmoi will prompt you for a choice.

### Notes

- The `input` section of `.config/niri/config.kdl` provides changes I like, such as swapping escape and caps lock, which you should remove if you don't need.

- My qutebrowser configuration emphasizes privacy over usability, and you might need to edit it to suit your needs if you want to use it.

- Neovim v0.12.1 is required; this version makes the configuration much simpler and easier to maintain.
  For older Neovim, use [commit 53ed26117](https://github.com/dogeystamp/dots/commit/53ed261172825f48245191254c98f81109fbfe45).

**Desktop Preview**

![preview](https://raw.githubusercontent.com/dogeystamp/dots/main/preview.jpg)
