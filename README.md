Dotfiles
========

Hi, you may remember these common dotfiles from such installs as Ubuntu 8.04
(April 2008 - Hello Linux Edition), Ubuntu 9.10 (October 2009 - Dist-upgrade
Failed, New OS Time, Edition), CentOS 5.6 (July 2011 - Feeling Experimental,
Edition), Ubuntu 10.04 (September 2011 - CentOS Was Awful, Edition), Linux Mint
13 (December 2012 - New Job, Edition), and Linux Mint 15 (July 2013, What Have
I Done, Edition).

Usage (simple)
--------------

- Clone
- Execute setup.sh (from anywhere, see extended usage for more options).
- Enjoy!

The default setup will install for desktop environments and MUST be run under
sudo in order to install system packages (etc.)

Usage (extended)
----------------

Usage: ./setup.sh [options]
  -e <stages(s)> A CSV-list of stages to exclude (default: ).
                   See -i for a full list of stages.
  -f             Force setup (by default anything that has already been setup
                   before will be skipped.)
  -m <mode>      Mode to setup (desktop/server, default: desktop)
                   This influences what is installed, where server mode
                   is for headless or terminal-only servers, possibly
                   without sudo access.  See -i for a full list of stages.
  -i <stage(s)> A CSV-list of stages to execute (default: all)
                   Stages (asterisks are desktop-only):
                    - dotfiles: Link dotfiles.
                    * colours: Setup terminal colours.
                    * fonts: Setup terminal fonts.
                    * libgcrypt11: Setup libgcrypt11 (Ubuntu 15.04+ only).
                    * packages: Install packages from packages.txt
                    - pip: Install pip/python packages from requirements.txt
                    - vundle: Install Vim Bundle (Vundle) plugins.
                    * ycm: Install YouCompleteMe (requires vundle installation).
                   E.g. to only link dotfiles, use -i dotfiles.
  -h           Display usage (this text)
