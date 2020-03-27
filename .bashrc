# ======================================================================
# This is my .bashrc for use on Windows for Linux Subsystem (WSL). It's updated along the way, as I get more hang of WSL.
# Working with bash in WSL is a bit different from using a "nativ" Linux/*BSD, among other things because the base system isn't running (completely anway) when bash is not start.
# Any form of feedback would be much appreciated: https://github.com/boegh/wsl/issues
# You may observe that I prefer functions rather than aliases in bashrc. I'm not sure why. I've done that for many years. There are probably arguments against doing it that way, but I'll continue do it for now. You can read more about Bash aliases/functions on https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
# You'll see the directory ~/WinHome/ on occation here. It is a symbolic link out of the WSL filespace to the Windows Home directory ( %userprofile% in Windows ).
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


/usr/bin/sudo /usr/sbin/service cron status > /dev/null

if [ $? -eq 3 ]
then
    /usr/bin/sudo /usr/sbin/service cron start
fi


# Start rsyslog - because we like logging (remember to add line to sudoers)


/usr/bin/sudo /usr/sbin/service rsyslog status > /dev/null

if [ $? -eq 3 ]
then
    /usr/bin/sudo /usr/sbin/service rsyslog start
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


# retrieve public keys from Keybase and store them in GPG keyring
# See https://github.com/keybase/keybase-issues/issues/1396 for more info


k2g() {
    /usr/bin/wget -qO - https://keybase.io/$1/key.asc | /usr/bin/gpg --import -
}


# nmap on WSL currently doesn't work as AF_PACKET needed by nmap (and other tools like wireshark) is not yet implemented.
# solution: Install the Windows version and alias to it from WSL
# See https://github.com/Microsoft/WSL/issues/1349

nmap() {
    /mnt/c/Program\ Files\ \(x86\)/Nmap/nmap.exe $@
}


# convert mkv files to gif files
# requires both ffmpeg (from package ffmpeg) and convert (from package imagemagick-6.q16)

mkv2gif() {
    if [ -f "$@" ]; then
	FILE="$@"
	FILENAME=${FILE%.*}
	/usr/bin/ffmpeg -i "$FILE" -vf scale=640:-1 -r 15 -f image2pipe -vcodec ppm - | /usr/bin/convert-im6.q16 -delay 5 -loop 0 - "$FILENAME.gif"
    fi
}


# convert a png to Windows icon - useful for Windows shortscuts to WSL executables
# Look in /usr/share/icons/ or /usr/share/<app name (-ish)>/icons
# requires imagemagick and puts the Windows icons in %userprofile%\bin.icon\.

winicon() {
    if [ -f "$1" ]; then
	FILENAME=$(basename $1)
	/usr/bin/convert $1 -define icon:auto-resize=64,48,32,16 ~/WinHome/bin.icon/$FILENAME.ico
    fi
}


# Export DISPLAY for X11. I'm using VcXsrv for the purpose. Starting it automatically with a shortcut in shell:startup of Windows and a saved configuration:
# "C:\Program Files\VcXsrv\xlaunch.exe" -run C:\Users\henri\default.xlaunch
# For some odd reason I can only get this to work properly if it is in the end of .bashrc...

export DISPLAY=:0.0
