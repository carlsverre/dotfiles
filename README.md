# Wat?

Most of what you need to replicate my dev environment on most machines.

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
- [ghostty](https://ghostty.org/)
- [maim](https://github.com/naelstrof/maim)
- [colorpicker](git@github.com:ym1234/colorpicker.git)
- [dragon](https://github.com/mwh/dragon)
- [gnupg](https://www.gnupg.org/)

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

```sh
./install.sh            # link the dotfiles, install whatever is missing
./install.sh --update   # the same, plus upgrade everything and prune old versions
```

One script does both machines; the linux-only bits are skipped on macos. It is
idempotent, so a second run should print nothing but `[ok]` lines.

Layout:

- `install.sh` — the whole sequence, top to bottom, no logic of its own
- `lib/*.sh` — function definitions only, sourced by `install.sh`
- `config/mise/config.toml` — every CLI tool, linked to `~/.config/mise`

[mise](https://mise.jdx.dev) owns the tools. Versions there are ranges, and an
installed tool stays put until `--update` moves it. Add a tool with `mise use -g
<name>@latest`, which writes back into the repo through the symlink; `mise
registry` lists what is available.

Python is the exception: mise installs `uv`, and uv owns the interpreters
(`uv python install --default` in `install.sh`).

This used to be [webinstall](https://webinstall.dev). `./bin/webi-purge` is a
one-shot that clears out what it left in `~/.local/opt`; run it once after the
first `./install.sh`, then delete it.

## Other apps I like to have

- beeper
- sioyek
- telegram
- zed
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

By default this repo will set the commit author to my (carlsverre) personal github noreply email address. You can modify this behavior by editing config/gitconfig.

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

**Fix keyboard repeat rate** [Arch docs](https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_AutoRepeat_configuration_option)

```xorg
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "AutoRepeat" "200 22"
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
