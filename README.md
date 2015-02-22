# Dotfiles

My OS X / Linux dotfiles.

## Why is this a git repo?

This was orginally a fork of Cowboy's Dotfiles(https://github.com/cowboy/dotfiles). I then began to modify some of it's core functionality to better suit my needs.

Changes/Modifications:

1. Cowboy's dotfiles made use of Bash as a default shell and would source Bash files. I use oh-my-zsh with my own custom setup.
2. I run most of my systems as a Standalone `non-sudo` user. 
3. Added support for checking if the dotfiles directory is dirty, as well as the ability to skip re-running dotfiles if dotfiles is up-to-date.
4. Added support for theme settings for sublime, iTerm and Terminal.app
5. Seperated functions into their own lib file, that also gets downloaded as needed.


That command is [dotfiles][dotfiles], and this is my "dotfiles" Git repo.

[dotfiles]: bin/dotfiles
[bin]: https://github.com/ravivcohen/dotfiles/tree/master/bin

## What, exactly, does the "dotfiles" command do?

It's really not very complicated. When [dotfiles][dotfiles] is run, it does a few things:

1. Git is installed if necessary (on Ubuntu, via APT. OSX is assumed to have GIT installed).
2. This repo is cloned into the `~/.dotfiles` directory (or updated if it already exists or quits if dirty).
2. Files in `init` are executed:
    * In alphanumeric order, hence the "50_" names 
    * With permission constraints, files < "50_" are run as sudo.
3. Files in `copy` are copied into `~/`.
4. Files in `link` are linked into `~/`.

Note:

* The `backups` folder only gets created when necessary. Any files in `~/` that would have been overwritten by `copy` or `link` get backed up there.
* Files in `bin` are executable shell scripts (Eg. [~/.dotfiles/bin][bin] is added into the path).
* Files in `conf` just sit there. If a config file doesn't _need_ to go in `~/`, put it in there.

## Installation

### Standalone user support
On my main machine, and in general, I tend to run as a non priviliged user. As such I make use of targetpw and runaspw see [man sudoers][http://www.sudo.ws/sudoers.man.html]. 
#### Setup
On OSX:
   We can enable the root user and then follow the [On rest][https://github.com/ravivcohen/dotfiles/edit/master/README.md]. I choose to not enable the root user and instead make use of runaspw, in combination with setting runas_default variable to a user who is an Administrator and as such sudo run commands under the Admin user and also allows your to run sudo -u root to run root commands the latter works because what sudo -u root with the runaspw set really mean sudo sudo.
   * Create a group, for ex non_admin
   * Add standard user you want to have sudo access to that group
   * Add the following to /etc/sudoers
     ```
     Defaults:%non_admin runas_default=ravivcohen, runaspw
     %non_admin ALL=(ALL) ALL
     ```
   

### General Notes

* In order to run init scripts files that have an alphanumeric value < "50_" require `sudo` privillgies.
   * __You can skip the entire "init" step when prompted.__
   * The reason it is all or nothing for the "init" step is because the sudo steps install necesary software needed by the rest of the script. 
   * I am working on making this more flexible. SEE ROADMAP
   * If you skip the "init" step, only copy/link will be executed.  

##### Run As Another User 
   
I tend to run as a non `sudo` privillged user on my systems. I therfore need to first `su` to a user that can `sudo` and run the commands as that user. The files are split up in the "init" script to run all files with < "50_" as a `sudo` user, this way only the stuff that really needs `sudo` runs.

* Upon execution you will be asked if you would like to `su` to another user which can `sudo`. 
   * When you choose "yes" all `sudo` commands will gets wrapped in `su $username -c 'sudo _command_`.


### OS X Notes

* You need to have installed [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a _much smaller_ download thank XCode.

__MORE OSs TO COME ...__

### Actual Installation

```sh
bash -c "$(curl -fsSL https://bit.ly/rc-dotfiles)"
```

If, for some reason, [bit.ly](https://bit.ly/) is down, you can use the canonical URL.

```sh
bash -c "$(curl -fsSL https://raw.github.com/ravivcohen/dotfiles/master/bin/dotfiles)"
```

## The "init" step
A whole bunch of things will be installed, but _only_ if they aren't already.

### OS X
* Hombrew taps
   * homebrew/dupes 
   * caskroom/cask 
   * caskroom/versions 

* Homebrew recipes
   *  readline --universal
   *  sqlite --universal
   *  gdbm --universal
   *  openssl --universal
   *  zsh 
   *  wget --enable-iri
   *  grep 
   *  git 
   *  ssh-copy-id  
   *  apg 
   *  nmap 
   *  git-extras
   *  htop-osx 
   *  youtube-dl 
   *  coreutils 
   *  findutils 
   *  ack 
   *  lynx 
   *  pigz 
   *  rename 
   *  pkg-config 
   *  p7zip 
   *  lesspipe --syntax-highlighting
   *  python --universal --framework 
   *  vim --with-python --with-ruby --with-perl --enable-cscope --enable-pythoninterp --override-system-vi
   *  macvim --enable-cscope --enable-pythoninterp --custom-icons
   *  brew-cask 

* Homebrew Casks
   * sublime-text3 
   * iterm2-beta 
   * java6 
   * xquartz 
   * tower 
   * transmit 
   * path-finder 
   * adium 
   * vagrant 
   * keka 
   * shuttle 
* Fonts - [lokaltog](https://github.com/Lokaltog/powerline-fonts) powerline fonts
   * font-dejavu-sans-mono-for-powerline 
   * font-inconsolata-dz-powerline 
   * font-inconsolata-powerline
   * font-meslo-powerline 
   * font-sauce-code-powerline
* OSX config script.

### Ubuntu
(Outdated)
* APT packages
  * build-essential
  * libssl-dev
  * git-core
  * tree
  * sl
  * id3tool
  * cowsay
  * nmap
  * telnet
  * htop

###Global
Runs on all install
* Ininital directory setup
* Sublime-text config is copied over
* Terminal themes are installed
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)


## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [.gitconfig](copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~/`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit that data!

## Aliases and Functions
To keep things easy, I make use of Robby Russel's [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). A custom .zshrc file is linked over and all my custom aliases functions go into [.oh-my-zsh-custom](link/.oh-my-zsh-custom) folder. All .zsh files in there will get sourced. 

## Scripts
On top of the scripts in [.oh-my-zsh-custom](link/.oh-my-zsh-custom), there are some custom scripts in the bin folder I use all the time:
   *  burp_download.py - Downloads and "install's" latest burp.
   *  manh & manp - Man page as html and pdf.
   *  multi-firefox - app-named profiles for firefox.
   *  scan - wrapper around nmap.
   *  subl - is a cli for sublime-text.

## Prompt
TODO

## Inspiration
TODO

## License
TODO
