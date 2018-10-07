# My .bashrc for WSL w/ Debian GNU/Linux
# $ uname -srvmpio
# Linux 4.4.0-17134-Microsoft #285-Microsoft Thu Aug 30 17:31:00 PST 2018 x86_64 unknown unknown GNU/Linux
#

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
DISPLAY="127.0.0.1:0.0"

shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

PS1="\[\e[0;32m\]\t \W\[\e[1;37m\]> "

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




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
	'/mnt/c/Users/polle/bin/totalcmd/TOTALCMD64.exe' $RWSLPATH &
	disown
    else
	echo "Error - path probably within WSL root"
    fi
}

Linux 4.4.0-17134-Microsoft #285-Microsoft Thu Aug 30 17:31:00 PST 2018 x86_64 unknown unknown GNU/Linux
