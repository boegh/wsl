This is where I put stuff related to Windows Subsystem for Linux (WSL).

**NOTE**: This page is work in progress (and will probably remain so for quite a while...)

Important stuff first - here are a couple of very good links for reference:
- [Microsoft Docs WSL interoperability with Windows](https://docs.microsoft.com/en-us/windows/wsl/interop)
- [MSDN Commandline blog w/WSL](https://blogs.msdn.microsoft.com/commandline/tag/wsl/)
- [MSDN WSL blog (not updated since april 2017)](https://blogs.msdn.microsoft.com/wsl/)

And a couple of Debian WSL specific links:
- [hanselman.com: The year of Linux on the (Windows) Desktop - WSL Tips and Tricks](https://www.hanselman.com/blog/TheYearOfLinuxOnTheWindowsDesktopWSLTipsAndTricks.aspx)
- [sirredbeard@github: Awesome WSL](https://github.com/sirredbeard/Awesome-WSL)

In mid-2018 I "discovered" [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) (WSL). While it is still a bit immature, it does looks so promising, that I've now nuked my Ubuntu installation and gone purely Windows.

#### Installing
I went into WSL with Debian as a starting point. Enabling WSL and installing Debian from the Store, was a very smooth process, that [is very well described here](https://docs.microsoft.com/en-us/windows/wsl/install-win10). The total process including first startup of the choosen distribution took less than 10 minutes.

#### Graphical applications
I quickly realized that I needed some form of way to get graphical applications working with WSL. The [VcXsrv](https://sourceforge.net/projects/vcxsrv/) seemed to be a quite well-functioning X-server under Windows, and I am now a happy user of that. Apps doesn't always run smoothly - i.e. Firefox is a bit of a heavy one, but the much lesser known and very lightweight browsers [Midori](https://www.midori-browser.org/) works quite well.
Making VcXsrv work with WSL took a bit of fiddeling, but after figuring out the hick-up (see comment in [my .bashrc](https://github.com/boegh/wsl/blob/master/.bashrc)) things are now working quite well. I can even watch (albeit without sound as I have not done anything to make that work) videos on YouTube etc. on a WSL based browser, displayed with VcXsrv :).

#### Limitations
Among other things WSL doesn't currently support neither [AF_PACKET (needed by utilities such as nmap, wireshark, tcpdump)](https://github.com/Microsoft/WSL/issues/1628) nor [block devices (needed to mount an external ext4 drive or use parted)](https://github.com/Microsoft/WSL/issues/689). As far as I can see, these are not simple limitations, but Microsoft haven't booted them as issues yet either, so that may happen at some point.
Also WSL is currently not doing any mapping to the Windows base user services. Users in WSL are completely independent of those in Windows. I hope in the future we will see full AD-integration and user control into WSL.

#### Tweaks to improve integration between WSL and Windows:
Other than the above mentioned, I've also made a couple of other tweaks:

1. I've created a number of shortcuts from ~ on WSL to similar directories on Windows (in %userprofile%):
```
lrwxrwxrwx 1 heb  heb     27 Sep 30 19:33 Desktop -> /mnt/c/Users/heb/Desktop/
lrwxrwxrwx 1 heb  heb     29 Sep 30 19:33 Downloads -> /mnt/c/Users/heb/Downloads/
lrwxrwxrwx 1 heb  heb     28 Sep 30 19:33 Pictures -> /mnt/c/Users/heb/Pictures/
lrwxrwxrwx 1 heb  heb     19 Oct  7 14:56 WinHome -> /mnt/c/Users/heb/
```
Having these makes moving between Windows and WSL a bit easier. Note while it is possible to access WSL rootfs from Windows, meddeling around there seems to be a bad idea. Probably due to the [way WSL filesystem (VOIfs) works](https://blogs.msdn.microsoft.com/wsl/2016/06/15/wsl-file-system-support/), but I'm not sure. But don't fiddle around that way. WSL seems to be able to access and operate most of the files in the Windows filesystem and that works quite well. Use the tool `wslpath` for converting the path from Windows to WSL (see example in my .bashrc).

1. I've made a number of "shortcuts" allowing me to open a Windows editor from WSL (only files outside of WSL root though), using nmap from WSL (by actually triggering the Windows nmap, as nmap - due to reasons stated under limitations - doesn't work under WSL) and starting Midnight Commander in the current directory (again: As long as it is not withing WSL root). They can all be found in my .bashrc.

