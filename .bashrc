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

/usr/bin/sudo /usr/sbin/service cron start


# Start rsyslog - because we like logging (remember to add line to sudoers)

/usr/bin/sudo /usr/sbin/service rsyslog start

### aliases etc.

wedit() {
    RWSLPATH=$(wslpath -w $(realpath $1))
    if [[ -n $RWSLPATH ]]; then
        '/mnt/c/Program Files (x86)/Notepad++/notepad++.exe' $RWSLPATH &
	disown
    else
	echo "Error - file probably within WSL root"
    fi
}

tc() {
    RWSLPATH=$(wslpath -w $(realpath $(pwd)))
    if [[ -n $RWSLPATH ]]; then
	'/mnt/c/Users/henri/bin/totalcmd/TOTALCMD64.exe' $RWSLPATH &
	disown
    else
	echo "Error - path probably within WSL root"
    fi
}

ytmp3dl() {
    /usr/local/bin/youtube-dl  --extract-audio --audio-format mp3 $1
}


# Export DISPLAY for X11. I'm using VcXsrv for the purpose. Starting it automatically with a shortcut in shell:startup of Windows and a saved configuration:
# "C:\Program Files\VcXsrv\xlaunch.exe" -run C:\Users\henri\default.xlaunch
# For some odd reason I can only get this to work properly if it is in the end of .bashrc...

export DISPLAY=:0.0
