# Wat?

Most of what you need to replicate my linux desktop environment on most machines. Periodically I even get this working
on OSX. :)

# Setup

## Dependencies

- [zsh](https://www.zsh.org/)
- [i3lock](https://github.com/i3/i3lock)
- [rofi](https://github.com/davatorium/rofi)
- [herbstluftwm](https://herbstluftwm.org/)
  - Need to install from source
  - Can wrap with sddm if needed
- [polybar](https://github.com/polybar/polybar)
- [google-chrome](https://www.google.com/intl/en_ca/chrome/)
- [dunst](https://github.com/dunst-project/dunst)
- [alacritty](https://github.com/alacritty/alacritty)
- [Nix package manager](https://nixos.org/download.html)
- [maim](https://github.com/naelstrof/maim)
- [colorpicker](git@github.com:ym1234/colorpicker.git)
- [dragon](https://github.com/mwh/dragon)

## Fonts

- [Lato](https://fonts.google.com/specimen/Lato)
  - `sudo apt install fonts-lato`
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
  - On linux:
  ```
  mkdir -p ~/.local/share/fonts
  wget -O/tmp/hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
  pushd ~/.local/share/fonts
  unzip /tmp/hack.zip
  popd
  fc-cache -f -v
  fc-list | grep Hack
  ```

## Install

- Run `./install.sh` to sync dotfiles into the homedir
- Run `./desktop.sh` to install lots of things

## Other apps I like to have

- [keybase](https://keybase.io/)
- beeper
- sioyek
- telegram
- UHK Agent
- vscode
- discord
- morgen
- chrome
- tailscale
- neofetch
- obs
- obsidian
- spotify
- slack
- feh
- zoom

# Helpful Snippets

## Managing git commit authorship

By default this repo will set the commit author to my (carlsverre) personal github noreply email address. You can modify
this behavior by editing config/gitconfig.

You can also override the commit email on a per-repo basis using `git set-email` which is provided in `./bin`.

```sh
# set a local email
git set-email foo@bar.com
# reset local email
git set-email --clear
```

If you need to amend a commit to fixup the author, use this command:

```sh
git commit --amend --reset-author
```

## Modify input device settings via Xorg.conf.d

- Tested on Debian
- Add files to `/usr/share/X11/xorg.conf.d`

**Fix keyboard repeat rate**
```xorg
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "AutoRepeat" "200 45"
EndSection
```

**Kensington Expert Wireless TB**

```xorg
Section "InputClass"
    Identifier "Expert Wireless TB"
    MatchProduct "Expert Wireless TB"
    Driver "libinput"
    Option "AccelProfile" "adaptive"
    Option "AccelSpeed" "-0.5"
    Option "ScrollMethod" "button"
    Option "ScrollButton" "8"
    Option "ButtonMapping" "1 8 3 4 5 6 7 2 9"
EndSection
```

**Microsoft Sculpt**

```xorg
Section "InputClass"
        Identifier      "Microsoft Keyboard"
        MatchIsKeyboard "on"
        MatchProduct    "Microsoft"
        MatchProduct    "Nano Transceiver"
        Option          "XkbOptions" "caps:escape"
EndSection
```

**Apple Magic Keyboard**

```
Section "InputClass"
  Identifier      "Apple Inc. Magic Keyboard"
  MatchProduct    "Apple Inc. Magic Keyboard"
  MatchVendor     "Apple_Inc."
  MatchIsKeyboard "on"
  Option          "XkbOptions" "caps:escape,altwin:swap_alt_win"
EndSection
```
