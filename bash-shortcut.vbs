' File to execute commands in bash, without opening a terminal window.
' Create a shortcut to the script and add the command as a paramter i.e.
' %userprofile%\bash-shortcut.vbs "export DISPLAY=:0.0 && /usr/bin/xmessage $(uptime)"

CreateObject("Wscript.Shell").Run "C:\Windows\System32\bash.exe -c  """ & WScript.Arguments(0) & """", 0, False
