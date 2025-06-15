# PEASS-updater

Simple Bash script that automatically downloads and updates the scripts/binaries from the PEAS suite with their latest releases. Also stores the scripts/binaries in a easy-to-access folder structure for quick use in your pentests and CTFs.

By default will download and update all Linux and Windows scripts/binaries. You can adjust which scripts/binaries will be downloaded and updated using flags. You can also enable downloading and updating scripts ONLY if the PEASS-ng git repo has been updated since the last time this bash script was run, using the corresponding flags.

## Usage  

```
./PEASS-updater.sh [OPTIONS]

Options:
	-h, --help
		Displays help information.
	-g, --git-check
		Enables downloading and updating scripts/binaries ONLY if the peass-ng git repo has been updated since the last time this bash script was run. Requires git. 
	-l, --linux-only
		Downloads and updates only Linux scripts/binaries (linpeas). Can't be used in conjuction with -w or --windows-only.
	-w, --windows-only
		Downloads and updates only Windows scripts/binaries (winpeas). Can't be used in conjuction with -l or --linux-only.
	-b, --basic
		Downloads and updates only the basic scripts/binaries (See note below). Can't be used in conjuction with -m or --minimal.
	-m, --minimal
		Downloads and updates only the minimal scripts/binaries (See note below). Can't be used in conjuction with -b or --basic.
	-c, --no-colors
		Disables use of colors in output.
	-v, --verbose
		Enables verbose output.

If you wish to change the scripts/binaries that will be downloaded and updated if basic or minimal modes are enabled, then change the corresponding arrays in the first lines of the code.
```

## Installing

Clone the git repository with ``git clone https://github.com/Picolin64/peas-updater.git`` and rename the main folder to ``peass``, or download directly the PEASS-updater.sh script and store it in a folder named ``peass``.

## FAQ

**Q: Why not just clone the PEASS-ng repository?**

**A:** The PEASS-ng repository doesn't contain most of the scripts and binaries you might need in its source code, only a few Windows binaries. Instead, almost all the scripts and binaries have to be manually downloaded in their releases page.

**Q: Why not simply use the peass package that can be installed with apt?**

**A:** The PEASS package that can be installed with apt isn't updated in a weekly basis, as opposed to the PEASS-ng repository. Also, the PEASS package installs ALL the scripts and binaries from the PEAS suite; but you may not want to use all of them. For example, you might just want to keep the most basic scripts and binaries updated such as linpeas.sh, winPEASx64.exe and winPEASx86.exe. You can download and keep updated only these few scripts/binaries with the -m or --minimal flags.

This script also allows to update the binaries and scripts only if the PEASS-ng repository was updated since the last time this script was run, using the -g or --git-check flags. These options might come handy for someone with slow internet speed, who knows. (Also I made this project mainly to practice Bash scripting, don't be hard on me).

## Bonus track

I have prepared some handy aliases to access directly the main folder and the linpeas and winpeas subfolders. And also to display the folder structure in a nice tree formatting with colors. Copy these aliases directly to your .bash_aliases, .bashrc or .zshrc file located in your home directory (or wherever your aliases are stored). Remember to change the path of the folders before using them.

```bash
# Fonts
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'
NORMAL='\e[0m'

alias peass='echo -e "> ${UNDERLINE}peass${NORMAL} ${ITALIC}~ Privilege Escalation Awesome Scripts SUITE${NORMAL}\n" && cd path/to/peass/main/folder && unbuffer tree -I "update-peas.sh" -I "README.md" | sed -e "0,/\./ s?\.?"`pwd`"?" -e "/files/d" -e "/^[[:space:]]*$/d"'
alias linpeas='cd path/to/linpeass/folder && unbuffer tree | sed -e "0,/\./ s?\.?"`pwd`"?" -e "/files/d" -e "/^[[:space:]]*$/d"'
alias winpeas='cd path/to/winpeass/folders && unbuffer tree | sed -e "0,/\./ s?\.?"`pwd`"?" -e "/files/d" -e "/^[[:space:]]*$/d"'
```

### Result

![peass-alias](./peass-alias.png)
![linpeas-alias](./linpeas-alias.png)
![winpeas-alias](./winpeas-alias.png)
