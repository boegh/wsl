# ======================================================================
# This is my .bashrc for use on Windows for Linux Subsystem (WSL). It's updated along the way, as I get more hang of WSL.
# Working with bash in WSL is a bit different from using a "nativ" Linux/*BSD, among other things because the base system isn't running (completely anway) when bash is not start.
# Any form of feedback would be much appreciated: https://github.com/boegh/wsl/issues
# ======================================================================

# Start out by entering home directory - no matter where bash is invoked from!
# I've experienced that bash hangs a couple of times when started from cmd in a directory that is not %userprofile%.
# I'm not sure why or how (suspect it is related to starting cron or syslogd in bashrc), but this seems to do the trick.

cd ~
# Bash stuff

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Regular stuff

shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

color_prompt=yes
PS1="\[\e[0;32m\]\t \W\[\e[1;37m\]> "

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom Stuff

export PATH=$PATH:~/bin


# WSL requires cron to be started everytime - remember to add the following to sudoers:
# 	$USER        ALL = NOPASSWD: /usr/sbin/service cron *
# and to put user into sudoers group:
# 	usermod -a -G crontab $USER


/usr/bin/sudo /usr/sbin/service cron status

if [ $? -eq 3 ]
then
    /usr/bin/sudo /usr/sbin/service cron start
else
  echo "Doing nothing..." >&2
fi


# Start rsyslog - because we like logging (remember to add line to sudoers)


/usr/bin/sudo /usr/sbin/service rsyslog status

if [ $? -eq 3 ]
then
    /usr/bin/sudo /usr/sbin/service rsyslog start
else
  echo "Doing nothing..." >&2
fi


### aliases etc.

# wedit is used to start Notepad++: an advanced text-editor for Windows - https://notepad-plus-plus.org/
# This command takes the file that the user wants to open as a parameter ($1) for application input

wedit() {
    if RWSLPATH=$(wslpath -w $(realpath $1) 2>&1); then
	if [[ -n $RWSLPATH ]]; then
	    '/mnt/c/Program Files (x86)/Notepad++/notepad++.exe' $RWSLPATH &
	    disown
	else
	    echo "Error code: $?"
	    echo "RWSLPATH: $RWSLPATH"
	fi
    else
	echo -e "\033[0;31mERROR\033[0m: $RWSLPATH"
	echo -e "       (Are you sure that $1 is OUTSIDE of WSL root?)"
    fi
}

# tc is used to start TotalCommander: a dual-pane filemanager for Windows - https://www.ghisler.com/
# This command uses the current directory ($(pwd)) for application launch

tc() {
    if RWSLPATH=$(wslpath -w $(realpath $(pwd)) 2>&1); then
	if [[ -n $RWSLPATH ]]; then
	    '/mnt/c/Users/henri/bin/totalcmd/TOTALCMD64.exe' $RWSLPATH &
	    disown
	else
	    echo "Error code: $?"
	    echo "RWSLPATH: $RWSLPATH"
	fi
    else
	echo -e "\033[0;31mERROR\033[0m: $RWSLPATH"
	echo -e "       (Are you sure that $1 is OUTSIDE of WSL root?)"
    fi
}

# ytmp3dl is a regular alias with a parameter (youtube video to download as mp3) for youtube-dl - https://github.com/rg3/youtube-dl/

ytmp3dl() {
    /usr/local/bin/youtube-dl  --extract-audio --audio-format mp3 $1
}


# Export DISPLAY for X11. I'm using VcXsrv for the purpose. Starting it automatically with a shortcut in shell:startup of Windows and a saved configuration:
# "C:\Program Files\VcXsrv\xlaunch.exe" -run C:\Users\henri\default.xlaunch
# For some odd reason I can only get this to work properly if it is in the end of .bashrc...

export DISPLAY=:0.0
#!/bin/bash


