# Dotfiles

My OS X / Linux dotfiles.

## Why is this a git repo?

This was orginally a fork of Cowboy's Dotfiles(https://github.com/cowboy/dotfiles). I then began to modify some of it's core functionality to better suit my needs.

Changes/Modifications:

1. Cowboy's dotfiles made use of Bash as a default shell and would source Bash files. I use oh-my-zsh with my own custom setup.
2. I run most of my systems as a Standalone `non-sudo` user. This means that to install parts of the init script that require root I must `su $username -c` to user that can `sudo`. I modified the script to support this, more information below.
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
* Homebrew recipes
  * git
  * tree
  * sl
  * lesspipe
  * id3tool
  * nmap
  * git-extras
  * htop-osx
  * man2html
  * hub
  * cowsay
  * ssh-copy-id
  * apple-gcc42 (via [homebrew-dupes](https://github.com/Homebrew/homebrew-dupes/blob/master/apple-gcc42.rb))

### Ubuntu
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

### Both
* Nave
  * node (latest stable)
    * npm
    * grunt-cli
    * linken
    * bower
    * node-inspector
    * yo
* rbenv
  * ruby 2.0.0-p247
* gems
  * bundler
  * awesome_print
  * pry
  * lolcat

## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [.gitconfig](copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~/`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit that data!

## Aliases and Functions
To keep things easy, the `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc into one of the files in the `source` subdirectory, or add a new file. They're all automatically sourced when a new shell is opened. Take a look, I have [a lot of aliases and functions](https://github.com/cowboy/dotfiles/tree/master/source). I even have a [fancy prompt](source/50_prompt.sh) that shows the current directory, time and current git/svn repo status.

## Scripts
In addition to the aforementioned [dotfiles][dotfiles] script, there are a few other [bash scripts][bin]. This includes [ack](https://github.com/petdance/ack), which is a [git submodule](https://github.com/cowboy/dotfiles/tree/master/libs).

* [dotfiles][dotfiles] - (re)initialize dotfiles. It might ask for your password (for `sudo`).
* [src](link/.bashrc#L6-15) - (re)source all files in `source` directory
* Look through the [bin][bin] subdirectory for a few more.

## Prompt
I think [my bash prompt](source/50_prompt.sh) is awesome. It shows git and svn repo status, a timestamp, error exit codes, and even changes color depending on how you've logged in.

Git repos display as **[branch:flags]** where flags are:

**?** untracked files  
**!** changed (but unstaged) files  
**+** staged files

SVN repos display as **[rev1:rev2]** where rev1 and rev2 are:

**rev1** last changed revision  
**rev2** revision

Check it out:

![My awesome bash prompt](http://farm8.staticflickr.com/7142/6754488927_563dd73553_b.jpg)

## Inspiration
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>  
(and 15+ years of accumulated crap)

## License
Copyright (c) 2013 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>
