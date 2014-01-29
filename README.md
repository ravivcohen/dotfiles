dotfiles
========

My collection of dotfiles as well as my private tool to clone and refresh them. 

It was orginally inspired by https://github.com/cowboy/dotfiles and has been heavily modified to suit my needs.

more to follow ... 

## Installation
### OS X Notes

* You need to be an administrator (for `sudo`).
* You need to have installed [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a _much smaller_ download thank XCode.

### Ubuntu Notes

* You need to be an administrator (for `sudo`).
* You might want to set up your ubuntu server [like I do it](/cowboy/dotfiles/wiki/ubuntu-setup), but then again, you might not.
* Either way, you should at least update/upgrade APT with `sudo apt-get -qq update && sudo apt-get -qq dist-upgrade` first.

### Actual Installation

```sh
bash -c "$(curl -fsSL https://bit.ly/cowboy-dotfiles)" && source ~/.bashrc
```

If, for some reason, [bit.ly](https://bit.ly/) is down, you can use the canonical URL.

```sh
bash -c "$(curl -fsSL https://raw.github.com/ravivcohen/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```
