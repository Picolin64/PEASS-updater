#!/bin/bash

# Author: Picolin64 (https://github.com/Picolin64)
# Automatically downloads and updates the scripts/binaries from the PEAS suite with their latest releases.
# Also stores the scripts in a easy-to-access folder structure for quick use in your pentests and CTFs.

LINPEAS=('linpeas.sh' 'linpeas_darwin_amd64' 'linpeas_darwin_arm64' 'linpeas_fat.sh' 'linpeas_linux_386' 'linpeas_linux_amd64' 'linpeas_linux_arm' 'linpeas_linux_arm64' 'linpeas_small.sh')
LINPEAS_BASIC=('linpeas.sh' 'linpeas_fat.sh' 'linpeas_small.sh')
LINPEAS_MINIMAL=('linpeas.sh')
WINPEAS=('winPEAS.bat' 'winPEASany.exe' 'winPEASany_ofs.exe' 'winPEASx64.exe' 'winPEASx64_ofs.exe' 'winPEASx86.exe' 'winPEASx86_ofs.exe')
WINPEAS_BASIC=('winPEAS.bat winPEASany.exe winPEASx64.exe winPEASx86.exe')
WINPEAS_MINIMAL=('winPEASx64.exe' 'winPEASx86.exe')

HELP=false
GIT_CHECK=false
LINUX_ONLY=false
WINDOWS_ONLY=false
MODE='all'	# all (default), basic or minimal
NO_COLORS=false
VERBOSE=false

HELP_DISPLAY="
peas-updater

By default will download and update all Linux and Windows scripts/binaries from the PEAS suite with their latest releases. You can adjust which scripts/binaries will be updated with the options below.

Usage: ./$(basename $0) [OPTIONS]

Options:	
	-h, --help
		Displays help information.
	-g, --git-check
		Enables downloading and updating scripts/binaries ONLY if the peass-ng git repo has been updated since the last time this bash script was run. Requires git. 
	-l, --linux-only
		Downloads and updates only Linux scripts/binaries (linpeas). Can't be used in conjunction with -w or --windows-only.
	-w, --windows-only
		Downloads and updates only Windows scripts/binaries (winpeas). Can't be used in conjunction with -l or --linux-only.
	-b, --basic
		Downloads and updates only the basic scripts/binaries (See note below). Can't be used in conjunction with -m or --minimal.
	-m, --minimal
		Downloads and updates only the minimal scripts/binaries (See note below). Can't be used in conjunction with -b or --basic.
	-c, --no-colors
		Disables use of colors in output.
	-v, --verbose
		Enables verbose output.\n

If you wish to change the scripts/binaries that will be downloaded and updated if basic or minimal modes are enabled, then change the corresponding arrays in the first lines of the code.\n
"

C=$(printf "\033")
NC="${C}[0m"
RED="${C}[1;31m"
GREEN="${C}[1;32m"
UNDERLINED_GREEN="${C}[4;32m"
YELLOW="${C}[1;33m"

print_usage() {
	printf "See the output of ./$(basename $0) -h for a summary of options.\n"
}

print_os_error() {
	printf "ERROR: -l (--linux-only) and -w (--windows-only) flags are exclusive. Use only one.\n"
	print_usage
}

print_mode_error() {
	printf "ERROR: -b (--basic) and -m (--minimal) flags are exclusive. Use only one.\n"
	print_usage
}

while [ $# -gt 0 ]; do
	case $1 in
  		-h | --help) 			HELP=true;;
		-g | --git-check) 		GIT_CHECK=true;;
		-l | --linux-only) 		if $WINDOWS_ONLY; then print_os_error; exit 0; fi; LINUX_ONLY=true;;
		-w | --windows-only) 	if $LINUX_ONLy; then print_os_error; exit 0; fi; WINDOWS_ONLY=true;;
		-b | --basic) 			if [[ $MODE != "all" ]]; then print_mode_error; exit 0 ;fi; MODE="basic";;
		-m | --minimal) 		if [[ $MODE != "all" ]]; then print_mode_error; exit 0 ;fi; MODE="minimal";;
		-c | --no-colors) 		NO_COLORS=true;;
		-v | --verbose) 		VERBOSE=true;;
		*) 						printf "Invalid option: $1\n"; print_usage; exit 0;;
	esac
	shift
done

if $NO_COLORS; then
	NC=""
	RED=""
	GREEN=""
	UNDERLINED_GREEN=""
	YELLOW=""
fi

print_success() {
	printf "${GREEN}[+] $1${NC}"
}

print_informational() {
	printf "${YELLOW}[*] $1${NC}"
}

print_failure() {
	printf "${RED}[-] $1${NC}"
}

# Print help if option was provided
if $HELP; then printf "$HELP_DISPLAY"; exit 0; fi

set -o pipefail -e	# This is needed to prevent incorrect behavior of the script on unexpected errors such as network issues and such

# If git-check option was provided, then check if git repo has been updated since the last time this bash script was run.
# Then update peass scripts only if the peass-ng git repo has been updated since the last time this script was run 
# using the git-check option (otherwise it doesn't keep track of the last hash commit).
# Requires git.

# Keep in mind that this option doesn't check if every individual script/binary is outdated. 
# If the git repo has been updated since the last time this script was run, then it will simply assume that all binaries/scripts are outdated.
if $GIT_CHECK; then
	if [[ ! "$(command -v git 2>/dev/null)" ]]; then print_failure "Git is not installed or couldn't be found.\n"; print_failure "Stopping!"; exit 0; fi

	CURRENT_COMMIT="$(git ls-remote https://github.com/peass-ng/PEASS-ng.git refs/heads/master | cut -f 1)"

	if [ -f ./.last-commit ] && [ -s ./.last-commit ]; then
		if $VERBOSE; then print_informational "File for storing last hash commit exists.\n"; fi
	else
		if $VERBOSE; then print_informational "File for storing last hash commit doesn't exist or is empty. Creating file '.last-commit'.\n"; fi
		touch ./.last-commit
	fi

	if [[ $CURRENT_COMMIT == $(cat ./.last-commit) ]]; then 
		print_informational "All scripts/binaries are already updated.\n"; print_informational "Stopping!"
		exit 0
	fi

	if $VERBOSE; then print_informational "Current scripts/binaries are outdated.\n"; print_informational "Updating last git hash commit for future reference.\n"; fi
	
	echo $CURRENT_COMMIT > ./.last-commit
fi

# Configure updating mode
case $MODE in
	"all")
		if $VERBOSE; then print_informational "Default mode enabled.\n"; fi
		LINPEAS_SCRIPTS=("${LINPEAS[@]}")
		WINPEAS_SCRIPTS=("${WINPEAS[@]}");;
	"basic")
		if $VERBOSE; then print_informational "Basic mode enabled.\n"; fi
		LINPEAS_SCRIPTS=("${LINPEAS_BASIC[@]}")
		WINPEAS_SCRIPTS=("${WINPEAS_BASIC[@]}");;
	"minimal")
		if $VERBOSE; then print_informational "Minimal mode enabled.\n"; fi
		LINPEAS_SCRIPTS=("${LINPEAS_MINIMAL[@]}")
		WINPEAS_SCRIPTS=("${WINPEAS_MINIMAL[@]}");;
esac

print_informational "Updating scripts/binaries...\n"

# Update/download linpeas
if ! $WINDOWS_ONLY; then
	if [ -d ./linpeas ]; then
		if $VERBOSE; then print_informational "Directory for storing Linux scripts/binaries exist.\n"; fi
	else
		if $VERBOSE; then print_informational "Directory for storing Linux scripts/binaries doesn't exist. Creating directory 'linpeas/'.\n"; fi

		mkdir linpeas	
	fi

	if $VERBOSE; then print_informational "Updating Linux scripts/binaries...\n"; print_informational "The following Linux scripts/binaries will be updated: ${LINPEAS_SCRIPTS[*]}\n"; fi

	for script in "${LINPEAS_SCRIPTS[@]}"
	do
		curl -LOs --output-dir ./linpeas https://github.com/peass-ng/PEASS-ng/releases/latest/download/$script
	done

	# Update permissions for linpeas bash scripts
	if $VERBOSE; then print_informational "Enabling execute permissions for Linux bash scripts (for everyone).\n"; fi

	chmod +x ./linpeas/linpeas*.sh

	if $VERBOSE; then print_success "Linux scripts/binaries have been updated!\n"; fi
fi

# Update/download winpeas
if ! $LINUX_ONLY; then
	if [ -d ./winpeas ]
	then
		if $VERBOSE; then print_informational "Directory for storing Windows scripts/binaries exist.\n"; fi
	else
		if $VERBOSE; then print_informational "Directory for storing Windows scripts/binaries doesn't exist. Creating directory 'winpeas/'.\n"; fi

		mkdir winpeas
	fi

	if $VERBOSE; then print_informational "Updating Windows scripts/binaries...\n"; print_informational "The following Windows scripts/binaries will be updated: ${WINPEAS_SCRIPTS[*]} \n"; fi

	for script in "${WINPEAS_SCRIPTS[@]}"
	do
		curl -LOs --output-dir ./winpeas https://github.com/peass-ng/PEASS-ng/releases/latest/download/$script
	done

	if $VERBOSE; then print_success "Windows scripts/binaries have been updated!\n"; fi
fi

printf "${GREEN}[+] ${UNDERLINED_GREEN}Scripts/binaries from the PEAS suite have been downloaded and updated successfully!${NC}\n"
set -o pipefail +e
