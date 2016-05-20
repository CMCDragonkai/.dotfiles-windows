# .dotfiles #

This directory is meant to be located in `~/.dotfiles`. It's files are supposed to be symlinked into `~`.

We can should have a bash script that basically symlinks only files and creates folders. Nothing else.

External dependencies are managed via git submodules. This facilitates component based development, where these dependencies have their own life cycle.

```
# add the master branch of prezto as a submodule
git submodule add -b master git@github.com:sorin-ionescu/prezto.git
# update the submodule to the latest master
git submodule update --remote prezto
```

Installation is:

```
cd ~
git clone --recursive https://github.com/CMCDragonkai/.dotfiles.git
```

SSH Keys are not stored in `~/.ssh` and the `~/.ssh/hosts` file is not stored there either. Make sure to securely transfer all keys and hosts file into `~/.ssh` before using.

```
scp ~/.ssh/identity cmcdragonkai@X.X.X.X:~/.ssh/identity
scp ~/.ssh/identity.ppl cmcdragonkai@X.X.X.X:~/.ssh/identity.ppk
scp ~/.ssh/hosts cmcdragonkai@X.X.X.X:~/.ssh/hosts
scp -r ~/.ssh/keys/ cmcdragonkai@X.X.X.X:~/.ssh/keys
```

We need a file that dictates the system dependencies required for this user configuration to work. Similar to import_exec.

While we have a local bin folder. This should contain shell utilities that can be executed for convenience to figure out things. They are each executables. Some of them are only relevant to Windows.

Definitely symlink files, and only create directories!

Where do I get the /usr/share/nano files? It would have to be part the /nix/store. Perhaps a symlink there? Is it available via static? How does a user specific script acquire the store path of a executable on the system?

May need to create a compilation system to make for windows or make for linux. We already have conditional aspects of the configuration suited to Windows or Linux. We can use compiler flags like preprocessors that embed or disembed. Or we can create 2 different versions of the same file. I think preprocessor flags would be the best. Investigate Shake.

# I also want one for rsync? And one for ssh where we forget about host key, like force option
# also something to automate nc with gpg, or gpg with talk
# nc require a listener and a transmitter, but the listener is just activated ad-hoc
# while talk requires a daemon, which can be port activated (talk uses port 518?)
# While talkd is available in inetutils, there's no service file for it yet that is port activated
# so... yea.
# https://wiki.archlinux.org/index.php/Talkd_and_the_talk_command
# ntalk is port 518 UDP and TCP #

Did GPG, Make/M4, Shake, GPG with netcat, talk/talkd, inetutils, Nixpkgs and the /usr/share problem (files inside packages that aren't binaries), SSH related utilities and rsync, global gitignore ignoring common temporary files like Vim swap files

When deploying on Windows. We need to first install Cygwin.

When deploying on Windows, we need to also build https://github.com/rprichard/winpty project. Attach it as a submodule here too. The resulting binaries need to be put into `~/.bin`. Many windows specific executables are to be symlinked with `console`. If you don't know. Leave it as is. This package is needed for Windows GHCI, Windows Python... etc. In most cases you want Cygwin executables. But somethings cannot be built on Cygwin yet. So you use Windows executables.

When deploying on Windows, somethings we cannot symlink. Instead either a shortcut or an NTFS symbolic link must be used. For example the Documents/WindowsPowerShell/Profile.ps1. Use the `mklink` alias to do this.

The below needs to run once on installation on Windows. The environment variable has to be on Windows machine, not shell specific environment variable.

```
setx CYGWIN "nodosfilewarning"
```

The first step on Windows, is to first get Cygwin. And then run any build tools. Such a build tool needs to be immediately accessible from Linux and Cygwin easily. That makes Shake a bad idea. Even Make a bad idea. Ultimately we just need a simple `install.sh` script.

Linux install script shouldn't symlink things that have `.ps1` or `.exe` or `.bat` or `.cmd` in them! And empty folders should also be ignored once files are ignored.

Interesting resource: http://stackoverflow.com/a/21233990/582917

Scrollback buffer search in Mintty doesn't work because of ConEmu. Can ConEmu replace this functionality? Or somehow let this pass?

Mintty
------

Useful shortcuts (see the rest at the Mintty manual `man mintty`):

* <kbd>Alt</kbd> + <kbd>Enter</kbd> - Enter and Exit Full Screen - doesn't work
* <kbd>Ctrl</kbd> + <kbd>+</kbd>/<kbd>-</kbd> - Font Zooming
* <kbd>Shift</kbd> + <kbd>Up</kbd>/<kbd>Down</kbd> - Scroll Line Up and Down
* <kbd>Shift</kbd> + <kbd>PgUp</kbd>/<kbd>PgDn</kbd> - Scroll Page Up and Down
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd>/<kbd>V</kbd> - Copy & Paste
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> - Search Scrollback Buffer
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> - Switch screens between orimary buffer and secondary buffer (like between shell and less or shell and vim)

Some shortcuts are not available because they are replaced by ConEmu equivalents.

We prefer ASCII DEL `^?` to be used for backwards delete instead of ASCII BS `^H`. Instead `^H` can be mapped to nother functions. Forwards delete still uses `\e[3~`. Preferably if the design of keyboards and terminals were standardised, we could have ASCII DEL for forwards delete, and ASCII BS for backwards delete, but alas it is not so.

Consolas is the chosen font at 13 point size for Mintty. Consolas is a monospaced programming font, and is already installed with Windows. It also has a wide range of glyphs and supports interesting kinds of unicode glyphs.

We're using a solarized dark scheme.

Use http://terminal.sexy/ to produce new colour schemes, and to translate them between different terminals or shells or editors.

ConEmu
------

Full screen doesn't work properly. We need to intercept and add full screen to ConEmu, not Mintty. Then we can disable `Alt + Enter/Space` buttons.

Terminal Emulator
-----------------

Our terminal emulator would preferably support sixel graphics, W3M images, and ligatures. Here we have the different terminal emulators to work with:

* Konsole - Supports Ligatures, only on Linux
* Gnome-Terminal - Supports W3m Images, only on Linux.
* Xterm - Supports sixel graphics, w3m images, only on Linux. Probably no ligature support.
* Mintty - No sixel, no w3m images, no ligatures, only on Windows.
* Conhost - Windows default terminal emulator for Powershell and CMD.
* ConEmu - Wraps up both Mintty and ConHost and other gui applications and manages them.

So for Windows, the stack is: ConEmu + Mintty/Conhost.

For Linux, the stack will be: Konsole. Because w3m images isn't that important, and sixel graphics is an oddity. We can use graphical Emacs instead for graphics and executable documents, no need for the terminal. But in the future if Konsole could support sixel graphics or w3m images, then it would be great! That being said, over SSH, support for sixel depends on client terminal emulator. And w3mimages doesn't work on Linux console anyway. The only way to get image support into terminals in modern day systems is to create a new standard such as iTerm2, or Black screen, or use support sixel graphics eventually. Until that day comes, we stick with KDE Konsole.

Editor
------




Fonts
-----

I desire fonts usable for both the terminal and editor, the most ideal ones are those that are multilingual, monospaced, supports ligatures, supports box drawing, supports powerline, supports a good number of unicode symbols and support even APL, but this probably doesn't exist. So we have a number fonts available to choose from in different situations:

* Anonymous Pro
* Source Code Pro
* FiraCode
* Monoid
* Hasklig

Paid Fonts:

* PragmataPro - Paid

Fallback Fonts:

* Consolas - Windows
* Inconsalata - Linux

Performance
-----------

To improve performance we need to use a macro language and produce a `.build` folder. This way we can generate the correct .zshrc and other rc files and eliminate sections from the language when we don't need it. It's simple conditional macro language. I wonder if there's a bash version around, so we don't need to use m4 or anything.

Windows
-------

# TODO: We need to run console.exe along with this to allow this work flawlessly in Cygwin mintty See the aliases for Cygwin, they mostly need to use `console`. Or `winpty`. #

Installation WIP
----------------

On installing this repository for use:

```
git clone --recursive <.dotfiles-repo>
# or on git 2.8
git clone <.dotfiles-repo> <.dotfiles-path>
cd <.dotfiles-path> && git submodule update --init --recursive --depth 1
```

We need to use:

```
# where --archive means: --recursive --links --perms --times --group --owner
rsync --update --checksum --archive "./dotfiles/.build/" "${HOME}/"
```

But also Make to run the rest.

Remember the correct permissions: `chmod 600 -R ~/.ssh`. And use the preprocessor on all relevant files including `~/.ssh/config`.

On installing this repository for development:

```
git clone --recursive <.dotfiles-repo>
# or on git 2.8
git clone <.dotfiles-repo> <.dotfiles-path>
cd <.dotfiles-path> && git submodule update --init --recursive
```

On adding new dependencies:

```
cd "$(git rev-parse --show-toplevel)"
git submodule add <repo> modules/<repo-name>
git submodule update --init --recursive --depth 1 modules/<repo-name>
```

On removing dependencies that have been committed:

```
cd "$(git rev-parse --show-toplevel)"
package="modules/package"
git submodule deinit --force "$package"
git rm --force "$package"
rm --recursive --force --dir ".git/modules/$package"
```

On updating dependencies to the latest in their branch:

```
cd "$(git rev-parse --show-toplevel)"
git submodule update --init --recursive --remote --merge modules/<repo-name>
```

On changing dependency upstream URL:

```
cd "$(git rev-parse --show-toplevel)"
git config --file=".gitmodules" "submodule.modules/<repo-name>.url" "<repo>"
git submodule sync
```

On checking submodule status:

```
cd "$(git rev-parse --show-toplevel)"
git submodule status --recursive
```

---

On Windows, open `Run` application and copy paste this command:

```
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Noninteractive -NoExit -File .\install.ps1
```

This script will not manage Windows GUI applications except for ConEmu.

The rest should be installed directly or using Chocolatey. But Chocolatey is outside the realm of this particular repository. This does mean dealing with things like Haskell Platform is outside the realm of this `.dotfiles`, except as configuration files.

---

Remember to properly configure Cygwin's home menu to be `%USERPROFILE%`.

Also note that there are 3 temporary directories for Cygwin use:

* User Local Temporary - `TEMP=%USERPROFILE%\AppData\Local\Temp`
* System Temporary - `TEMP=%SystemRoot%\TEMP`
* Cygwin Temporary - `export TMPDIR=/tmp`

We need a differentiation between the temporary directories due to different expectations of permissions between Cygwin (Linux) and Windows. So when clearing the temporary directory, feel free to clear `/tmp` and also the user local temporary. System temporary should be carefully cleaned. In order to allow access to the windows tmp, in Cygwin, the `WINTMP` is set to the original user local temporary. System temporary is not directly accessible, but that's alright.

---

`%ALLUSERSPROFILE%` - Points to a common user profile directory (that is viewable by all users on the OS). We should create a `%ALLUSERSPROFILE%/bin` directory to add PATH symlinks to all Windows executables that we install into here (this makes sense as installed Windows executables are usually installed on the entire system, not for a particular user). This refers to any natively installed Windows executable, or any extracted Windows executable. This does not refer to Chocolatey's installed executables, which has its own bin path at `%ALLUSERSPROFILE%/chocolatey/bin`. Note that Chocolatey will not necessarily install bin links for every package. Look for packages with a suffix of `.portable`. Do not use `.install` unless you verify its behaviour. Note that `.install` refers to natively installed packages, and these packages cannot be auto-uninstalled, without first uninstalling it natively, then uninstalling it from Chocolatey. Packages without a suffix are usually meta-packages. But make sure to review them before installing.

This means we need specifically, PATH needs to be set up in this way:

* Default Windows Paths (on Windows): `C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\`
* Prepend Chocolatey path (on Windows): `%ALLUSERSPROFILE%\chocolatey\bin`
* Prepend custom Windows path (on Windows): `%ALLUSERSPROFILE%\bin`
* Prepend Cygwin paths (on Cygwin): `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin`
* Prepend Home paths (on Cygwin): `~/bin`

What this means is that Windows executables will always be available to Windows executables, but both Windows and Cygwin executables will be available to Cygwin executables and Windows executables executed through Cygwin.

Only one problem, Powershell scripts in `~/bin` won't be available to Powershell by default. The way to solve this is to put in `~/Documents/WindowsPowerShell/profile.ps1` an extra piece of code to set `%USERPROFILE%/bin` as prepended as well. This way, all user executed powershells will gain access to `~/bin`. Also to make sure that `PATHEXT` also contains `.PS1`. All of this is done currently.

As for `CMD`, this is fixed via `~/.cmd_profile`. Which you need to hook into any call via `cmd /K %USERPROFILE%/.cmd_profile`.

You must RAID your Windows Disks to get a single disk. Don't spread out the disks. This prevents problems with Chocolatey not allowing one to install into different drive letters.

---

Search.

The Search Field in ConEmu only applies to ConHost applications.

Things like Powershell and CMD that uses Windows ConHost.

If you are running mintty, the search field in ConEmu does not work.

Instead Mintty has its own search functionality.

This is because mintty is a terminal emulator itself, and ConHost is  Windows terminal emulator!

Also scrollbars on ConEmu only applies to ConHost applications as well. Mintty manages its own scrollbar.

Hey double clicking on a tab will max/restore a ConEmu panel.

Perhaps we should no be using ConEmu for terminal window management for Mintty. But instead tmux. Whereas ConEmu's terminal window management is relegated to Windows ConHost terminals. So right now I'm interesting in making the tab switching work, which should easily transition to panel switching. In fact switching between tabs is switching between different panels right now. It's just that CTRL+TAB doesn't work because Mintty/Putty captures it and prevents it from being used. Furthermore, more than just tab/panel switching, is the ability to launch panels, instead of launching tabs, easy keyboard hotkey for doing so. Launching panels will be really useful for certain things. Then keyboard controls for controlling the size of the panels easily. While this would be great for powershell and CMD, it's not really useful for Mintty. Instead Mintty will need to use tmux. So we have 2 levels of terminal window management lol.

Since on Windows, we have free access to the `WIN` key. We should make use of that to control ConEmu. In Linux, the `WIN` key will be the key for XMonad.

---

A simple bin program that launches something an automatically detaches it from the terminal. By default, launching an X program should mean that the program should forward their errors to the standard error handling mechanism of X, that of `~/.xsession-errors`. But how does one detect if it's an X program? And even so, how do we know `~/.xsession-errors` exists? What about logs for command line programs? This will make such a program equivalent to an application launcher like demenu and launchy. See: http://unix.stackexchange.com/questions/86698/where-does-the-output-from-an-application-started-from-the-window-manager-go and http://unix.stackexchange.com/questions/86698/where-does-the-output-from-an-application-started-from-the-window-manager-go#comment129472_86808 IS IT REALLY THE SDDM/GDM/KDM that redirects stuff, or is it X server settings that sets the logging? https://marc.waeckerlin.org/computer/blog/get_rid_of_xsession-error_that_s_filling_up_the_home_directory Also this may be relevant: http://dtach.sourceforge.net/

---

Design hotkeys around 2/3 systems: XMonad -> Konsole -> Tmux -> ZSH on Linux, and on Windows: Windows Shell -> ConEmu -> Mintty -> Tmux -> ZSH. We'll need to have hotkey escalation, using the Mod key (Win key), Alt, Ctrl, Shift (left and right are equivalent).

---

KDE Konsole:

Notation:

* `\C` - <kbd>Ctrl</kbd>
* `\S` - <kbd>Shift</kbd>
* `\M` - Mod/Meta/Super which is <kbd>Win</kbd> on Windows, or <kbd>Cmd</kbd> on Mac. We want to avoid having to use <kbd>Alt</kbd>.
* `\A` - <kbd>Alt</kbd> on Windows Keyboards, or <kbd>Option</kbd> on Mac.
 `-` - Means hold previous, and hit the next, operator is left associative. `\C-\S-f` means `((\C-\S)-f)`
* ` ` - Means lift previous, and hit the next, operator is left associative. `e c t` means `((e c) t)`.
* `<enter>` - The Enter Key
* `<home>` - The Home key.

* `\C-\S-f` - Search Scrollback

---

Shell Commands:

`\C-c` - SIGINT
`\C-\` - SIGQUIT
`\C-z` - Toggle backgrounding and foregrounding.
`\S-<enter>` - Non-executing enter, allows multiline commands.

Hotkey Hierarchy:

Linux Commands -> XMonad Commands -> Konsole Commands -> Tmux Commands -> Shell Commands -> Application Commands
Windows Commands -> ConEmu Commands -> Mintty Commands -> Tmux Commands -> Shell Commands -> Application Commands

---

ls /dev/ | grep tty # only on Linux, the actual Linux console
ls /dev/ | grep pty # cygwin has this, and I think X as well
ls /dev/ | grep pts # not sure

Each terminal represents a `pty` or `tty`. You can then do `echo "haha" > /dev/tty0` or something to send output to another terminal emulator.

Remember it sends to the terminal emulator, not the shell that it is running. So this is an interesting way of sending side by side output. If we can easily acquire the address of particular terminal emulator.

Fortunately it's easy. All you need is to run `tty` on the terminal emulator you're in. And you get the address to it.

However consider if we can add this address persistently to the UI that runs the terminals. Like ConEmu, or Mintty, or Tmux.

To find out who's listening:

fuser /dev/pty2
fuser --verbose --user /dev/pty2
fuser --user /dev/pty2

That gives you the shell. Or something, not the PID of the terminal emulator. The parent of the shell would be the terminal emulator, which is useful. Works even with nested commands, like if a shell ran less or another shell.

Actually we don't even need to run `tty`, we can just `echo $TTY`.

Who sets $TTY? Don't know. But bash didn't have TTY, so let's just force TTY setting.

Now we just need something to add TTY to the window name of Mintty. Not sure.

Also Windows con hosts get /dev/cons0 but this is not usable because of a limitation of Windows. So they get tty too, but its useless.

* Investigate where TTY environment variable was set in ZSH
* Make $TTY appear in Mintty's window title (or ZSH's RPROMPT).
    - http://randomartifacts.blogspot.com.au/2012/10/a-proper-cygwin-environment.html
* Make $TTY appear in Tmux's panel title (or ZSH's RPROMPT).
* Install stderred (https://github.com/sickill/stderred), however no CYGWIN support, also no bash support
* Alternatively have explicit color http://stackoverflow.com/a/16178979/582917

---

NixOS:

* User Application Desktop Files: `~/.nix-profile/share/applications`
* System Application Desktop Files: `/run/current-system/sw/share/applications`

Non-NixOS:

* User Application Desktop Files: `~/.local/share/applications`
* System Application Desktop Files: `/usr/share/applications` or `/usr/local/share/applications`

Basically on NixOS, all local software can be found in `~/.nix-profile`, while all system softwareis in `/run/current-system/sw`.

We can create our own non-nix `*.desktop` files by putting them in `~/.local/share/applications`.

We could create a simple application launcher (similar to dmenu) that looks in just these directories for `*.desktop` files, and launching them. Such a launcher should only look for `*.desktop` files and not executables in general, because many executables are terminal executables, and we expect visual feedback from launching the executables. Imagine launching `ls`, it do nothing. Unless of course, we wrapped `ls` in a `*.desktop` file that made sure to launch it in the default terminal first.

I do have some further launcher ideas, namely combining persistent terminal with quake terminal with launcher prompts. But currently I don't know how to execute a `*.desktop` file as if it was launched by X directly, and make sure all X application logs go to `.xsession-errors`.

If we can do it cross platform:

* Mac: open
* Cygwin: cygstart
* Windows (non-cygwin, msys, mingw, powershell): explorer
* Linux: should be xdg-open, but it doesn't wor

Remember the requirement is to open the X application as if it was launched from display manager/window manager directly.

See: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/display-managers/default.nix#L42-L44 It's not guaranteed that the display manager will redirect output to `.xsession-errors`. It's handled by the `.xsession` script that is executed once the display manager logs you in.

It could work if the logfile of `.xsession-errors` was lifted (abstracted) up to be a nixos option. Then a launcher can take the same parameter, well actually one would pass the same file/place to the same parameter. Preferably we want to push such logs to journalctl.

---

Timezones

On installation and bootstrapping, these files need to be setup for Cygwin environments. Not NixOS.
Based on installation of tzcode package in Cygwin. Note that Linux the package is often called tzdata.

Run:
tzselect
Or automatically acquire from tzutil, but then you need to map it.

echo "$timezone" > /etc/timezone
ln --symbolic --force /usr/share/zoneinfo/"$timezone" /etc/localtime
ln --symbolic --force /usr/share/zoneinfo /etc/zoneinfo

Then automatically set `TZDIR=/usr/share/zoneinfo` and `TZ="$timezone"`.

OH so this explains it: http://man7.org/linux/man-pages/man3/tzset.3.html

Windows:

tzutils /g -> shows current timezone id
tzutils /l -> list of timezones
tzutilz /s -> sets the timezone

The timeone ids for Windows is not the same as the POSIX timezone ids. 

Why did nobody just use goddamn UTC+X or UTC-X, and be done with it.. instead, everybody has different codes.

---

Mintty keycodes are: https://github.com/mintty/mintty/wiki/Keycodes

Konsole keycodes, you have to discover yourself using showkey.

Quick way of testing on bash:

```
bind '"\e[Z":"\C-v\C-i"'
```

---

Try: http://input.fontbureau.com/

---

Look into gnu stow for installation of the configuration files.

---

ConEmu configuration

We want to show tty on the window name, to allow easy display redirection.

We want to use Ctrl + Tab to switch between tabs, or at least switch between tabs in ConEmu.

Remember:

Shift + Tab is now Literal Tab.
Ctrl + Tab is unknown...

In Konsole, tab control is:

* C-S-Left - move tab position
* C-S-Right - move tab position
* S-Left - move to previous tab
* S-Right - move to next tab
* S-Tab - move to next view container, no idea what this is, so we disable it!

In ConEmu, moving tabs is:

ConEmu's tab control is more important right now, because we have XMonad in Linux

I don't know where it is, but theres:

.config/konsolerc
.local/share/konsole
.local/share/kxmlgui5/konsole
.local/share/kxmlgui5/konsole/konsoleui.rc
.kde/share

Ok, so let's see if we can change tab shifting to use `S-Left` or `S-Right` as well..

Win + Alt + P - show settings (works in mintty)
Win + Alt + W - close terminal (does work in mintty)

Cursor Information is useless because it only works in ConHost, not mintty.

BufferHeight mode is for ConHost, as inits on for Powershell and CMD, but not for Mintty. This is a good thing, it allows scrolling.

TSA is the icon panel on the bottom in Windows. Taskbar Status Area.

Always use Segoe UI for Tab Font and Status Bar Font, and Segoe UI Mono if available.
By default, make Consolas the font for Console main and alternative, or Segoe UI Mono if available.
Size 18.

Status bar now shows the active process on the left. Which is the parent process. The console itself.
`mintty.exe*[64]:3352`. The 3352 is the Windows PID. It's not MINTTY that contains the TTY. But the it's the SHELL that is associated with the tty. Using `ps -a`, it shows MINTTY with WINPID and CYGWIN PID as 3352, while it has unknonw tty. That's because the ttys are actually for the shell itself.

So that means the WINPID for mintty is always the same as the CYGWIN PID for mintty.

On the far right, we have the Console Server PID. This is not related to Mintty or ZSH. It is related to ConEmu's server PID for each terminal launched inside ConEmu. 

```
# let's say ConEmu is a super terminal emulator
# we have 6 ConEmuC processes, serving 6 terminal emulators
ConEmuC.exe - 1492 - serving 32bit CMD
ConEmuC64.exe - 204 - serving 64bit CMD
ConEmuC64.exe - 4396 - serving 64bit powershell
ConEmuC64.exe - 5324 - serving 64bit mintty
ConEmuC64.exe - 2156 - serving 64bit mintty
```

It appears that ConEmuC* is the actual container that holds the terminal application? The terminal application for Cygwin is just mintty. Whereas for Windows, we have a conhost and its related shell. So a conhost + cmd, or a conhost + powershell.

Actually we also have 6 conhosts equaling 6 terminal emulators. So I'm guessing, even mintty requires its own conhost.
Yep. So closing a mintty terminal, results in closing a ConEmuC* process AND a conhost process. Along with the entire mintty process treey as well.

We have 1 extra processes that I'm not sure what they are:

```
ConEmu64.exe
```

I think, this is the main ConEmu process. that launches the ConEmuC containers, which then launch conhosts with terminal emulators like mintty, cmd, powershell.

The ConHosts are considered "Window Processes". Perhaps part of the kernel.
The Mintty and CMD and Powershell are considered "Background Processes".

```
# all background processes
Terminal - Mintty
Windows Command Processor - CMD
Windows Powershell - Powershell
```

The ConEmuC processes are also considered "Background Processes".

```
ConEmu console extender (x64) - ConEmuC64.exe
ConEmu console extender (x86) 32 bit - ConEmuC.exe
```

The ZSH is also considered "Background Processes".

The only thing considered to be "User Process" is ConEmu64.exe. And it also represents a group that you can switch to.
And that is the actual super parent process that starts the entire process tree.

```
# here's a tree with Process Name and Actual Executable:
Console Emulator (x64) [ConEmu64.exe]
    -> ConEmu console extender (x86) (32 bit) [ConEmuC.exe]
        -> Console Window Host [conhost.exe] & Windows Command Processor (32 bit) [cmd.exe]
    -> ConEmu console extender (x64) [ConEmuC64.exe]
        -> Console Window Host [conhost.exe] & Windows Command Processor [cmd.exe]
        -> Console Window Host [conhost.exe] & Windows PowerShell [powershell.exe]
        -> Console Window Host [conhost.exe] & Terminal [mintty.exe]
            -> zsh.exe [zsh.exe]
```

At the `mintty.exe`, the PPID of `mintty` is 1. So each mintty process is currently the first process past PID 1. However it seems that there is no PID 1. So therefore each mintty is its own process tree, and there is no further parent to consider.

If you use `ps -W`, to get Windows processes as well. It will show that the PPID of Windows processes from the perspective of Cygwin is 0. Meaning they don't have a PID 1. This is because they are out of the control of Cygwin.
There fore any process in Cygwin with a PPID of 1, is itself basically PID 1, it is the init. And you can have many inits running at the same time. Currently everytime I run a new Cygwin, this creates a whole new init.

The left number on the status shows the cmd.exe/powershell.exe/mintty.exe PID. Which is the same as the Cygwin PID.

The right number on the status shows the ConEmu console extender process ID.

Not sure why you need to know these PIDs though.

Supposedly if you close Console Emulator, you should close everything. However somethings get detached. And the thing I think is being detached is conhost.exe. We can try this now.

Actually they don't live a process tree. They are completely independent. Killing Console Emulator simply results in leaving detached and independent ConEmu console extender processes. They are all by themselves now... Everything keeps running.

However, although they keep running, they are no longer usable. We require the ConEmu64.exe to actually render contents onto the terminal. Without it, even though the extenders are running. They don't show anything anymore. Thye just show the cmd stuff for the extenders.

The only thing that acts like a process tree is the ConEmu extenders. Killing one of the extenders, results in killing the conhost and cmd.

I'm not sure if conhost under the cmd, or above the cmd? I'd think it's above the cmd right...

5144

6028
6036
888

If you kill cmd, you lose the conhost. It's automatic.
If you kill conhost, you lose the cmd. It's automatic.

This implies they are not in a parent child relationship, but a symbiotic relationship. Between Windows processes and background processes

If you kill one of the ConEmuC processes, it does not kill the Console Window host or the Terminal emulator being ran. However the window for rendering still does not appear. 

The cmd however is repainted, and we can now view it.

Wait but if it's a windows CMD, you do get it repainted.

Killing one of the conhosts, doesn't kill the bound CMD nor Mintty. I still have 2 MINTTY, and 1 CMD. Even though I killed the conhost. However I no longersee an appplication inside the taskbar.
Killing a mintty, doesn't kill zsh.

CMD is bound to Conhost. but not mintty. killing conhost for a mintty doesn't kill mintty. kiling conhost for cmd, does kill the cmd.
Killing zsh doesn't kill ssh-agent.

THAT IS SO WEIRD. It's like Windows doesn't have the concept of process trees.

The task manager is not very useful here. We need to use Windows Process Explorer.

There are so many "orphan processes" on Windows, if you don't use the GUI close buttons.

There's a difference between an child process, an orphan process and a zombie process. We can almost set this as a finite state machine. 

Child processes can be fundamentally started in either "fork" or "spawn" modes. Spawn is how you do it in Erlang and Windows. Fork is how you do it in Unix. However POSIX added "posix_spawn" that also allows one to do spawn in POSIX OS now!

Don't use orphan processes to create services/daemons. Create services using a service wrapper! Use your init's service wrapper capabilities. Systemd has services. So does Windows. Using orphan processes for services/daemons is totally deficient!! But you ask, what about user local processes!? Well systemd has user services too! Then you ask, what if I just want to run a long running process, and not look at it, and log out of SSH? I don't have the ability to create service! Well then that's when you us a terminal multiplexer called tmux or screen to create detached sessions! In no situation is orphaned processes the right answer. EXCEPT under one/two circumstance. When launching X applications or DE applications from the command line. That's the only time it makes sense to orphan a process, when it's like a GUI application that you want to launch independently. In that case, you're creating a "launcher", which is really a specific situation! It makes sense in this case, because firstly you don't want to control the process from the terminal (not even send signals), and it's not a long running daemon either, so it's not a service. Alternatively, if you do have tmux or screen, orphaning may not be required either. As you can just launch into detached sessions. HOWEVER this is kind of inefficient, as there's lots of baggage being carried around. Or you can just orphan it and make it be handled as an independent process. The only time where this makes sense is GUI applications like launching firefox.. etc. Make sure to attach its error handling into the X or DE based error handling. Which should be journald or syslog or .xsession-errors.

Process explorer shows how it really works. The process tree actually starts from Launchy, showing ConEmu64.exe, then the ConEmu64C, then a combined conhost with mintty or cmd. Processes launched by Mintty are not part of the process tree at all according to Windows, but are completely independent processes. ZSH, less and ssh-agent are all as if they are independent. Closing ConEmuC64 through official means, will close both the mintty, all of its processes and conhost. HOWEVER, if we close a terminal emulator, while it has processes running in its job control. Mintty warns that there are still processes running. These processes are not terminated. Which why I see a `conhost.exe` and `less.exe` left behind.

```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the
       state of a process:

               D    uninterruptible sleep (usually IO)
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent
```

However Cygwin's ps is a custom ps: https://cygwin.com/cygwin-ug-net/ps.html It only has 3 status codes: `S I O`, meaning stopped or suspended, waiting on input (interactive applications are like this), and waiting on output.

The WINPID from Cygwin, can be used to kill processes using https://cygwin.com/cygwin-ug-net/kill.html `kill --force`. Without the `--force` option, the PIDs are considered CYGWIN PIDs, not Windows PIDs.

Top also shows 3 sleeping processes, 1 stopped process, and 1 running process.

What I'm concerned about, is that closing the ConEmu terminal, doesn't close the conhost or the suspended/running processes that are inside mintty. That being said, the zsh and ssh-agent process does get closed. It's just the less and a conhost doesn't get closed, and becomes orphaned processes. Because less is an interactive process, it is left to run. And becomes orphaned. Because it is an interactive process, it requires a conhost. If you kill less, the conhost disappears along with it. It's almost as if the conhost represents a "pty". Does each orphaned process require its own conhost? Yep, we are left with only 1 conhost. Only 1 conhost is required to satisfy the pty processes. It does feel like a conhost is used to supply a pty. But hold on. Do we really need it? What if I launch a mintty by itself alone. Definitely conhost is created for every mintty.

Now why does ZSH and ssh-agent get closed regardless? It must be because those are not considered jobs... Not jobs of ZSH. Mintty closes, and closes its immediate child processes. That is the ZSH and SSH-Agent. But if Mintty cannot force close the grandchildren. It is up to ZSH to terminate the processes when it closes as well. This should be happening right? Each process can only terminate its immediate children, they cannot touch its grand children. That's how the fork fork exec style of orphaned processes work. That's my theory currently.

So this must mean.. that when closing a conemu terminal emulator, it only warns if the processes have child processes. Because by itself, only ZSH and ssh-agent is available, and these are closed all the time. So the warning is coming from MINTTY, and it cannot close grandchildren, so there are grandorphans being left behind.

See the Mintty option:

> Prompt about running processes on close (ConfirmExit=yes)
> 
> If enabled, ask for confirmation when the close button or Alt+F4 is pressed and the command invoked by mintty still has child processes. This is intended to help avoid closing programs accidentally. If possible, mintty also displays a list of running child processes, using the procps command if installed, or the ps command.

Ok, so what is goal here. The goal should be that, that if the terminal emulator closes, all transitive children processes should close with it. No orphans allowed!

> When you close a GNOME Terminal window, the shell process (or the process of whatever command you instructed Terminal to run) is sent the SIGHUP signal

> A process can catch SIGHUP, which means a specified function gets called, and most shells do catch it. 

> Bash will react to a SIGHUP by sending SIGHUP to each of its background processes (except those that have been disowned).

Right.. so it seems that ZSH is not sending SIGHUP to its child processes that are in the background (except those that have been disowned). Now I have not disowned any of my background processes in ZSH. So what is happening here!?

This shows something like: http://unix.stackexchange.com/a/176866/56970 Where gnome-terminal with bash can execute gnome-terminal with bash. But normally upon closing, child gnome-terminal will not be killed because it was never a child gnome-terminal. Launching a subsequent gnome-terminal looks for an original gnome-terminal window, and attaches to that. Killing the original gnome-terminal window, simply kills that gnome-terminal session. Not the new session. But this feature can be disabled, so it behaves like a child process in a process tree.

We need to differentiate "running" "executing" and "launching". "Launching" is always a matter of turning it into a orphaned process. Similar to using cygstart. It's an app launcher. But "running" or "executing" means preserving a process tree. And becoming a supervisor for that smaller process. 

So what's currently happening is that ZSH is one leaving orphaned processes all the time. Which it should not be doing. Orphaning should be explicit using disown or nohup.

Secondly, ZSH is always launched as a login shell. That doesn't make sense. On Linux, a login shell makes sense at the very beginning, launching tty0 and the tt7. But once you have your DE running, a login shell should always be created upon creating a terminal session. Instead, it should only be interactive. Our `cygwin.bat` is currently always running with `zsh -l -i`. I don't think `-l` makes sense here. But I'm not sure whether this is true. But on Windows, what does it mean to have a login shell!? I think there is no login shell when launching from Windows. The only login shell that can occur, is when running sshd on cygwin, and when a user logs in through SSH, only then would there be a login shell.

Therefore, login shell scripts should not run when simply executing ZSH from mintty.

Remember:

```
Setting up ZSH
--------------

Go into `/etc/passwd`, change the `:/bin/bash` to `:/bin/zsh` for the users that want ZSH as their default shell.

You can also edit the Cygwin.bat in the Cygwin installation directory. And change the `bash --login -i` to `zsh -l -i`

`-i` - force shell to be interactive

`-l` - means run a login shell
```

Now, the startup task from ConEmu is: `C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -`

So ConEmu is definitely launching mintty. But mintty must be launching Cygwin, which ends up launching ZSH. the cygwin.bat is currently:

```
@echo off

C:
chdir C:\cygwin64\bin

zsh -l -i
```

This tests whether we are in a login shell:

```
if [[ -o login ]]; then; print yes; else; print no; fi
```

It prints yes.

> When you start a shell in a terminal in an existing session (screen, X terminal, Emacs terminal buffer, a shell inside another, …), you get an interactive, non-login shell. That shell might read a shell configuration file (~/.bashrc for bash invoked as bash, /etc/zshrc and ~/.zshrc for zsh, /etc/csh.cshrc and ~/.cshrc for csh, the file indicated by the ENV variable for POSIX/XSI-compliant shells such as dash, ksh, and bash when invoked as sh, $ENV if set and ~/.mkshrc for mksh, etc.).
> http://unix.stackexchange.com/a/46856/56970

It supports the concept that once we're in tty7. We should be launching non-login interactive shells. Only on Linux, opening ttys and logging in via SSH, should we be getting interactive-login shells!

I don't think that `Cygwin.bat` is being used from mintty. They just aren't actually using it. It's still giving me a login shell.

If you run `C:\cygwin64\bin\mintty.exe` you end up with non-login shell. If you run `C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -` you end up with a login shell. ALSO a bunch of errors occur if you run a non-login shell.

Apparently I got the idea for running Cygwin from the shortcut called "Cygwin64 Terminal". This can be accessed via launchy actually and it's a Windows shortcut residing in: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Cygwin`. It's where the shortcut specifies: `C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -`. Why does this change the behaviour of ZSH?

THERE WE GO. It's in Mintty's manual:

```
       If a program name is supplied on the command line, this is executed with any additional arguments given.  Otherwise, mintty
       looks for a shell to execute in the SHELL environment variable.  If that is not set, it reads the user's default shell setting
       from /etc/passwd.  As a last resort, it falls back to /bin/sh.  If a single dash is specified instead of a program name, the
       shell is invoked as a login shell.
```

I see now. So it's looking for $SHELL, then looking at /etc/passwd. Taking it off, does result in executing a non-login ZSH shell now. HOWEVER I have now a bunch of errors relating:

```
/cygdrive/c/Users/CMCDragonkai/.rvm/scripts/rvm:12: command not found: uname
/cygdrive/c/Users/CMCDragonkai/.rvm/scripts/rvm:15: command not found: ps
__phpbrew_set_path:5: command not found: tr
__phpbrew_set_path:5: command not found: tr
/cygdrive/c/Users/CMCDragonkai/.zshrc:102: command not found: cygpath
/cygdrive/c/Users/CMCDragonkai/.zshrc:149: command not found: cygpath
/cygdrive/c/Users/CMCDragonkai/.zshrc:150: command not found: cygpath
/usr/bin/env: ‘zsh’: No such file or directory
/cygdrive/c/Users/CMCDragonkai/.oh-my-zsh/lib/completion.zsh:28: command not found: whoami
/cygdrive/c/Users/CMCDragonkai/.oh-my-zsh/lib/theme-and-appearance.zsh:10: command not found: uname
/cygdrive/c/Users/CMCDragonkai/.oh-my-zsh/lib/theme-and-appearance.zsh:14: command not found: uname
git_prompt_info:1: command not found: git
```

It's as if, not being a login shell causes problems!

So this means.. what exactly? It must mean that the login shell is being executed.

Ok SO basically we have 2 launching points:

```
C:\cygwin64\bin\mintty.exe
C:\cygwin64\Cygwin.bat
```

Both have options. The Cygwin.bat is the official launching point of Cygwin. So whatever you put there, is going to be executed, when you launch "Cygwin".

At this point here:

```
@ECHO off

REM Go into the Cygwin's binary directory, and launch ZSH as the shell 
CD /D C:\cygwin64\bin

zsh -i
```

Is what's executed!

What Cygwin.bat is for, is that it does not launch any kind of fancy terminal emulator. It uses Window's normal conhost terminal emulator. It needs to get to Cygwin's bin directory before it can launch zsh. This is because ZSH is not part of the Windows PATH. So this batch executable is hardcoded with the actual directory it is in. We can do better. We can make it execute based on where it's current directory is, and then go into bin. So it's a relative directory.

A better batch script would be (REMEMBER to replace the batch script with this):

```bat
@ECHO off

REM Navigate to cygwin's bin directory in order to access the ZSH shell
REM CD /D %~dp0\bin

CD /D %UserProfile%

REM Launch mintty as our terminal emulator
%~dp0\bin\mintty %*
```

This makes sure to look up just the current file's directory and get to the bin directory to get the ZSH executable. This is required because normally CD navigates according to the caller's CWD. So this just makes sure that the CWD is sent to the right place. This also means, that the batch script `Cygwin.bat` should always be located in the Cygwin directory.

If running `mintty.exe` directly goes to /usr/bin, why does ConEmu's zsh launch command go to `~` even when both commands are the same?

Ok I get it now.

* `Cygwin.bat` - Official Cygwin launcher. Because it starts as a Windows Batch File, it only has access to Windows environment variables.
* `mintty.exe` - Launches Mintty directly. It has a number of command line flags that changes its behaviour, and it will autolaunch the default shell for the user. It has the capability of launching the shell as a login shell or just a normal interactive shell. The autolaunching of the shell works by: checking SHELL executable, reading /etc/passwd before falling back onto /bin/sh.

ConEmu and the shortcut both currently directly execute `mintty.exe`: using "C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -".

What we want to do is align the behaviour. So I changed Cygwin.bat to be the above and use `mintty.exe`. Therefore. The `Cygwin.bat` should really be the official launching point. Should not call mintty directly.

However there's a problem. Using ConEmu to call the `Cygwin.bat` script, results in ConEmu running cmd, which runs the batch script, which runs the mintty. And this means only the cmd is attached to the ConEmu, while the mintty is running by itself in a detached window! Unfortunately there's no such thing as an "exec" in Windows. So we're stuck here. We cannot use `Cygwin.bat` normally from ConEmu. Instead ConEmu, needs to directly call `mintty` for it accurately attach itself to ConEmu as a GUI window. Finally it can pass arguments into mintty. Note that `mintty` vs `mintty -D`. `mintty -D = cygstart mintty`. It has become an orphaned process. I don't like calling it "daemonising", instead it's really orphanising. Daemonising should be reserved for service wrapping.

Ok so ConEmu should launch `mintty.exe` directly. Just that is enough!

Who's changing the starting directory? It's easy. It's ConEmu that is always launching the terminal emulator at the right place. Mintty doesn't know where to go. And neither does Cygwin.bat. So it that's why it always ends up at /usr/bin. Because that's where cygwin64/bin. There's a way to solve this. In the batch script, we just navigate to home, but run mintty from bin.

---

Even exit from ZSH, the ZSH warns that we have suspended jobs in background. And if we run exit again. We get the same deal. The same thing from kill the entire terminal emulator from outside. As in killing mintty. The less process is still running.

Nope. Running `kill -HUP $$` still results in less being orphaned.

* `exit` - leaves orphaned process after 1 warning
* `kill -HUP $$` - no warning, but still leaves orphaned process
* Mintty Close from GUI - warning from mintty, but still leaves orphaned process
* <kbd>Ctrl</kbd> + <kbd>D</kbd> - warning from ZSH, but still leaves orphaned process
* Task Termination - no warning, leaves lots of orphaned processes

Shit!

Bash, correctly kills child processes upon leaving. It kills from Mintty Close from GUI and `exit`. The less gets removed even as suspended. And also there's still a warning too.

Running from Cygwin.bat. Bash performs properly. But ZSH actually ends up leaving ssh-agent but killing less, when GUI window is closed... but running exit, leaves less and ssh-agent running. What the hell!?

However `cygstart mintty /bin/bash` performs properly. While `cygstart mintty /bin/zsh` does not kill child processes.

But this makes no sense. `shopt huponexit` shows that it's false by default. So what is closing less if bash isn't...? Is bash actually receiving a sighup from MINTTY or something? There's no way. Even exit is killing things!

Wait, `cygstart mintty /bin/bash` does not start a login shell. It's an interactive shell. Maybe that's something different?

Bash doesn't seem to need `shopt huponexit` to actually kill child processes. They just are killed! I HAVE NO IDEA!!!

http://superuser.com/q/662431/248499

Even though. We still need to make sure shopt huponexit is enabled for Bash. It's the only safe thing!

> Bash seems to send the SIGHUP only if it self received a SIGHUP, which for example occurs when a virtual terminal is closed or when the SSH connection is interrupted. From the documentation:

By default, this only happens when VT is closed or SSH connection is interrupted. But it doesn't happen for normal exit or EOF character. So huponexit is required. What's confusing, is that my Bash is already killing child processes no matter what anyway. But ZSH isn't! It's super annoying! Not to mention the fact that `huponexit` is only effective for interactive login shells. So it's still possible to have non-login interactive shells that exit and leave child processes running as orphans. But doesn't seem to occur on my Cygwin system.

Note that running `disown -ah` and `disown %1` ends up working on Bash too, the processes are not terminated upon Bash being closed. So why does Bash have the right behaviour here?

Killing a process tree is more difficult than I first imagined. Solutions include:

1. Traverse the tree
2. Use process groups (this is the most official way to do it)
3. Use a container (cgroups, control groups)

Because SIGKILL is unhandleable, SIGKILL is the most dangerous. As no parent process can possibly close their child processes and propagate any kind of signals (usually SIGHUP) to descendant processes. By definition SIGKILL will kill parents and leave orphans behind. It's an evil signal. Usually a well behaved process that behaves like a supervisor, should upon receiving SIGTERM/SIGHUP/SIGQUIT, should propagate them to their children. And the children should also propagate them further if they are to behave like supervisors too.

This explains the concept of using PROCESS GROUPS. http://stackoverflow.com/a/15139734/582917 Which I guess is the Unix/Linux way of setting up supervisors.

Yep this makes more sense now: https://en.wikipedia.org/wiki/Process_group

```
# this actually kills a process in the foreground of another terminal
kill -STOP $PID # "suspended (signal)"
kill -CONT $PID # do not touch anything here, otherwise "suspended (tty input)", and no automatically HUP
kill -HUP $PID # "continued -> hangup"
```

While this doesn't work:

```
kill -TSTP $PID # "suspended"
kill -CONT $PID # "suspended (tty output)"
kill -HUP $PID
```

We cannot `HUP` something until it is continued first. This makes sense as Bash does this, as it says that when it exits, it will first send SIGCONT before SIGHUP. However for some reason SIGCONT does not work on SIGTSTP programs?

WHAT the hell is:

suspended - SIGSTSP (suspended by Ctrl + Z)
suspended (signal) - SIGSTOP (suspended by kill -STOP $PID)
suspended (tty input) - SIGTTIN (like read backgrounded, or kill -TTIN $PID)
suspended (tty output) - SIGTTOU (suspended when stty tostop is activated, and is a background process, and or kill -TTOU $PID, or when the shell responds a process like less when backgrounded or suspended)

Ok here's what happens (note that ZSH job status is more detailed that Bash, Bash just calls everything "Stopped" when suspended):

```
less file : running
Ctrl + Z : suspended
bg %1 : continued -> suspended (tty output)
kill %1 : terminated
```

```
less file & : running -> suspended (tty output)
kill %1 : terminated
```

```
stty -tostop
cat random & : running -> done
```

```
stty tostop
cat random & : running -> suspended (tty output)
fg %1 : done
(sleep 10; echo "haha"; ) | cat : running@subshell && running@cat -> done@subshell && suspended (tty output)@cat
fg %1 : done@subshell && continued@cat -> done@subshell && done@cat
```

```
# how to make this read input as backgrounded job?
# there's no corresponding command for input like stty tistop
# this is because, it's very very unlikely you would want a backgrounded job that asks for input to take control over the terminal without explicitly foregrounding the job in the shell
# therefore processes that read in the backgrounded are always suspended with SIGTTIN
read & : running -> suspended (tty input)
```

```
echo -e "#/usr/bin/env bash\nx=$(read)" > /tmp/test.sh
chmod 100 /tmp/test.sh
/tmp/test.sh : running
Ctrl + Z : suspended
bg %1 : continued -> suspended (tty input)
kill %1 : terminated
```

```
Ctrl + Z -> SIGTSTP
bg %1 -> SIGCONT (but stay in background)
fg %1 -> SIGCONT (but bring to foreground)
by default, reading means SIGTTIN
by default, for less outputting means SIGTTOU
using stty tostop, for cat outputting means SIGTTOU
```

Note that `continued` always mean transitioning to `running`, before being potentially `suspended`.

FSM.

What is the difference between less and cat?

And what relationship does this have with ZSH not being killing child processes, and SIGTTIN and SIGTTOUT.

The thing is that, SIGSTOP is not what Ctrl + Z sends. And you cannot easily fg the process back. You can try, but it results in weird rendering issues. Obviously SIGSTSP is meant for actual suspension from a terminal emulator and in ZSH. But it doesn't seem to respond to SIGCONT properly. There must be other signals or something that is managing the input/output properly? What exactly is fg or bg?

Also if already STSP, and you use bg %1, you get -> continued -> suspended (tty output).

bg is actually SIGCONT
but what is fg?

This guy seems to know it: http://stackoverflow.com/questions/1844232/sending-a-signal-to-a-background-process#comment1738206_1844440

It appears that `suspended (tty output)` means the process tried to write to the shell, but the shell blocked it, and signaled to the process `SIGTTOU`. Which makes sense. As the shell tries to stop backgrounded processes from writing to it. Think of it like this. Consider that less needs to output the file contents. So in a shell if you write `less file &`, first it gets backgrounded, but since its backgrounded, as it tries to write output, it immediately receives `SIGTTOU`. Ok.. then what about `cat file &`? This doesn't get suspended at all, instead it immediately goes to `done` status, and it also outputs the content directly onto the shell. This could mean either `cat` doesn't care about `SIGTTOU`, or it has something to do with the fact that cat doesn't take control of the entire terminal, only gives back content via a pipe.

> If you really, really want to have something running in the background and still able to write to the TTY, turn off the tostop flag.
> `stty -tostop`

It appears that `stty --all` shows that `-tostop` is actually set. So the terminal does get backgrounded output.

Running:

```
# enable terminal output suspension for backgrounded jobs (all backgrounded jobs)
# stty means "set tty"
stty tostop
echo 'random' >/tmp/random
cat /tmp/random &
```

Does actually now produce a job that is suspended: `suspended (tty output)`. Which you need to `fg %1` to get the actual output.

But why does less automatically get `suspended (tty output)` when giving it to the background?

You can disable this feature again, which is by default `stty -tostop`. It appears to be a shell independent thing. `stty` is something else.

> The same behaviour is found when the shell is executing code as the right hand side of a pipeline or any complex shell construct such as if, for, etc., in order that the entire block of code can be managed as a single job. Background jobs are normally allowed to produce output, but this can be disabled by giving the command ‘stty tostop’. If you set this tty option, then background jobs will suspend when they try to produce output like they do when they try to read input. 

---

Implement this: http://unix.stackexchange.com/a/68635/56970
Showing job count on the prompt if there are jobs.

We should make sure `stty tostop` is enabled in our shells. Because it makes sense not to split background jobs. However this can be problematic, if we want to run a backgrounded job that will output its status, and mix it up with 2 different jobs at the same time. Sometimes we see ourselves using multiple jobs at the same time, and we want their status reported at the same time. That will require running `stty -tostop && { e; e; }; stty tostop` command to set -tostop for one set of tasks, then reset it back.

Wow you can do this:

```
read -r line < /dev/pts/0
```

And you can write and just get it done. Cat doesn't work well though.

Also launch 3 terminals. Output stdout to one, stderr to another. Write commands in the first terminal. Use `exec 2>/...` and `exec 1>/...` in the first terminal. One could create a little command for doing this.

Core dumps are only enabled upon using `ulimit -c unlimited && kill -QUIT command && ulimit -c 0`. That is we need to first set unlimited, then send SIGQUIT, then reset the core limit. This is to prevent apps from producing huge files all the time. In most cases, gcore is probably more useful than SIGQUIT. However one can run an application in debugging mode using it, so that when there's SIGSEGV or SIGABRT or SIGQUIT, then a core dump is generated. But you also have to remember the original setting of ulimit.

---

On Linux:

```sh
# ZSH orphaning

sleep 1000 &| # orphans the process (not part of the job table)

nohup sleep 1000 >/dev/null 2>&1 & # orphans the process (by default nohup sends to nohup.out) (still on job table)

{ sleep 1000 &; } && disown # orphans the current process (disown disowns the most "current" process) (not part of job table)

( sleep 1000 & ) # orphans the process immediately (not part of job table)
```

Orphaning doesn't occur immediately. The process is still considered as a child process of the parent shell. This is because orphaning is implicit. If the parent process doesn't wait on the child (assuming the child finishes), or kill the child (where the child is non-terminating). Then the child process gets inherited by init PID 1. Therefore those commands are simply commanding the shell, not to kill the child processes (that are in the background), when you close.

Except for `( sleep 1000 & )` which ends up orphaning the process IMMEDIATELY. And of course not part of the job table.

---

You can split view in Konsole for 2 windows. Basically it's like clone view. Like Sublime's "New View into File". It will create a split screen. That by default shows you the same shell already have. Thus cloning the view, into the same shell session. This allows nifty things like cloning your actions from one window to another (well Konsole panel to another), which might be useful for multiple monitors. But also I use Sublime's "New View into File" when I want to view a file in 2 places at the same time. It's useful for dealing with long files. But Sublime designed it so that you actually get 2 different cursors in the 2 views. Whereas Konsole only gives 1 cursor. So when one is editing, the others are view only. So it doesn't really work with Vim, because Vim only knows 1 cursor as well. It really only works well with programs that create a scrollbar. So with Konsole, you can scroll up in one view, while not affecting the other. The problem is that vim doesn't create a scrollbar. Well Konsole doesn't create a scrollbar for Vim. But Konsole does create a scrollbar for the scrollback for ZSH. So it really only works for programs that don't use the alternate screen. That being said you can launch tabs, then assign the view to that tab. So now you can have split screen tabs. Making Konsole into a terminal multiplexer, not just a emulator. Protip: you can make less not use the alternate screen by using `less -X file`. The `less -X` prevents initialising using termcap. So the output appears just as inline output for the main screen. It's probably not what you want. But you can use it now with Konsoles cloned view feature.

---

2 useful utilities:

* `edituser`
* `winln`

The `winln` becomes useful in the case of the below privilege is enabled. However it's still not as good as CMD's `mklink`. Due to some missing metadata. It just means you need to create a new Administrator CMD window each time to create a native Windows symlink.

```
# this can only be run in administrator mode
edituser -u CMCDragonkai -l
edituser -u CMCDragonkai -a SeCreateSymbolicLinkPrivilege
```

We need to make our install.ps1 powershell script grant `SeCreateSymbolicLinkPrivilege` to the current user. Something like:

```
# Grant Windows symlink creation permission to current user
# This is a call from carbon module, not part of default Powershell

Grant-Privilege -Identity "$Env:UserName" -Privilege SeCreateSymbolicLinkPrivilege
```

However this command only is available from the Carbon module: http://get-carbon.org/Grant-Privilege.html

Get that as a submodule dependency from Bitbucket.

Or instead of loading an entire module, consider: http://www.leeholmes.com/blog/2010/09/24/adjusting-token-privileges-in-powershell/

---

Try out:

`ktrash`, `gvfs-trash`, or `trash-cli`.

http://www.bramschoenmakers.nl/node/610.html
http://superuser.com/questions/324128/two-commands-to-move-files-to-trash-whats-the-difference

Would be good to create an alias depending on what's installed, and an adapter to Powershell.

---

Try out Cyberduck on Windows, specifically https://duck.sh/ or Dolphin network filesystem or Ranger/Total Commander. I need some sort of file browser (preferably command line and GUI) that can transparently access local and remote filesystems over multiple protocols. So not only SFTP, SCP, FTP, FTPS, but also things like S3, Backblaze, Azure would be great. Support mounting on the filesystem, so other programs can also utilise it.

---

SQL IDE:

* DBeaver - Cross Platform, Cross Database
* SQL Power Architect Community Edition - Cross Platform, Cross Database
* MySQL WorkBench - Only MySQL
* Valentina Studio - Cross Platform, Cross Database
* HeidiSQL - Windows, Cross Database
* Kexi - Linux version of Microsoft Access

---

Control the buffering:

* `unbuffer` or `zpty` - uses PTY (which forces line buffering or byte buffering, no idea)
* `stdbuf` - uses LD_PRELOAD (you can choose to do block buffering, line buffering, or no buffering)!

---

Local source goes into `~/src`. Local binaries goes into `~/bin`. Anything here is unmanaged by Nix and unmanaged by Cygwin. And I'm not following `/opt` or `/usr/local` because that goes against Nix. And is system wide. Anything system wide should be managed by Nix. And on Cygwin, the main user is the only one that matters.

---

Install picocom (because Cygwin doesn't have the package):

```
mkdir --parents ~/man/man1
cd ~/src \
&& git clone https://github.com/npat-efault/picocom \
&& cd picocom \
&& make \
&& ln --symbolic --force $(pwd)/picocom.exe ~/bin/picocom \
&& ln --symbolic --force $(pwd)/picocom.1 ~/man/man1/picocom.1
```

Why use `ln` instead of `install`? The `install` copies into the directories. That may not be a good thing. That being said, linking to the finished executable might involve less headaches? The advantage is that installing means you can delete the source if necessary. While linking means less duplication if you're keeping the source around. Also some packages already have `make install` as well, which may not be a good thing to run, if you want to use symlinks.... Yea for `~/src` packages, they should also use only `make` and direct `symlinking` to acquire. That way we know where all installed stuff from src is located in a central place. Easy enough to cleanup. Perhaps even a hardlink might be useful here.

It also means we know everything will be installed into `~/man`, `~/bin` or `~/info`.

---

Use http://rmlint.readthedocs.io/en/latest/index.html to clean up local directories. Especially for broken symlinks.

---

We should only have `~/man/man1`. Nothing else should be there. As for `~/info`. It's all just `~/info/program.info`. Always.

---

Asynchronous ZSH/Bash startup: http://stackoverflow.com/questions/20017805/bash-capture-output-of-command-run-in-background Some of our complicated startup can be used like `stty < ./.cygwin_stty &`. At the end run `wait`. But the point is, in some cases we need to capture the output of the asynchronous command. So the command needs to buffer up the output.

---

https://en.wikipedia.org/wiki/K-Lite_Codec_Pack

---

Skype on Linux is a bit weird, especially with Xmonad. Basically closing it with keyboard doesn't really close it. It's still running in the background. The GUI just disappears. It probably minimises to the tray. You need to use `kill <pid-of-skype-processes>` or just the quit button in the menu. Also the layout can be modifier with XMonad as well.

---

One of the problems with using pass or keybase, is that the database is one single file. Now to tranport any kind of secret, or even be able to share a secret, you have to share the entire dump. Unlocking to get a single secret means unlocking the entire thing. The thing is too bulky, and is not modular. That is the secrets are all lumped into one single thing, and it's not cohesive. We need to make secret management more cohesive, so an application or a usecase situation can demand just a specific secret, and not all. It's all about the principle of least privilege. This means fundamentally we need a secret server, not just a single secret file dump. A secret server that can provide API access (filtered and time constrained access) to secrets while also supporting privilege groups, and secret changing. And of course very detailed logging of where secrets are being requested from. Integrated password rotation. But that may be difficult. It needs to alert about password rotation, but the password manager may itself not have the privileges to do so. As in higher level privileges may be required for secret rotation.

---

The most common font that I can install for terminal emulators has got to be `DejaVu Sans Mono`.

Folds work by levels. As in, there's a invisible column called the fold column. And as you move this fold column around, it will fold things, or unfold them. 

We basically set the fold column to 1 + the highest fold level, you can see the fold levels in your code using `set foldcolumn=1`.

---

You actually need to do `chmod 700 -R ~/.ssh`. Not `600`. Without the `executable` permission, you can't view the directory.

---

So vim has buffers and tabs. And `:buffers` or `:ls` and `:vsplit` is awesome.

The commands:

```
:split
:vsplit
```

Split the windows equally, and always shows a duplicated view of the buffer you're currently looking at. This sounds likes what you're looking for in your hybrid TUI and GUI. The idea of always duplicating your current buffer is a good idea.

And also focus is always placed on the new buffer being split. So horizontal split means the new buffer should be the bottom one, while vertical split means the new buffer should the right one. Focus is always placed onto the new window.

Wait so now we have XMonad -> Tmux -> Vim Buffers/Windows???

And also Explorer -> ConEmu -> Tmux -> Vim.

Vim tabs are meant to be a different layout. Actually vim tabs is similar meaning to XMonad workspace. Workspaces usually is placed onto another monitor. But it doesn't need to be. It can be overlayed and stacked on top of each other.

1 X Screen -> X Monitors -> Y Workspaces(Tabs) -> Z Windows

Sometimes like ConEmu, the tabs themselves are windows. So they don't have a separate workspace. Except as program tabs inside explorer. Like having a different ConEmu.

Basically the concept of "tabs" is amorphous. For XMonad, tabs refers to workspaces. For Vim, tabs is also a form of workspaces. However in Sublime, tabs are actually per-buffer. While ConEmu, tabs is equivalent to windows. Basically the concept of a tab is kind of different across different things. One can make Vim do 1 buffer 1 tab. But that's what it was originally designed for.

Vim currently keeps the focus on the original buffer. And instead I would suggest the new buffer should be the focus. But I guess that's configurable.

> A buffer is the in-memory text of a file.
> A window is a viewport on a buffer.
> A tab page is a collection of windows.