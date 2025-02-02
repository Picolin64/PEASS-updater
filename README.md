# peas-updater

Simple bash script that automatically downloads and updates the scripts/binaries from the PEAS suite with their latest releases. Also stores the scripts/binaries in a easy-to-access folder structure for quick use in your pentests and CTFs.

By default will download and update all Linux and Windows scripts/binaries. You can adjust which scripts/binaries will be downloaded and updated using flags.

## Usage 
```
./update-peas.sh [OPTIONS]

Options:	
	-h, --help
		Displays help information.
	-g, --git-check
		Enables downloading and updating scripts ONLY if the peass-ng git repo has been updated since the last time this bash script was run. Requires git. 
	-l, --linux-only
		Downloads and updates only linux scripts (linpeas). Can't be used in conjuction with -w or --windows-only.
	-w, --windows-only
		Donwloads and updates only windows scripts (winpeas). Can't be used in conjuction with -l or --linux-only.
	-b, --basic
		Downloads and updates only the basic peass scripts (See note below). Can't be used in conjuction with -m or --minimal.
	-m, --minimal
		Donwloads and updates only the minimal peass scripts (See note below). Can't be used in conjuction with -b or --basic.
	-c, --no-colors
		Disables use colors in output.
	-v, --verbose
		Enables verbose output.\n

If you wish to change the scripts/binaries that will be downloaded and updated if basic or minimal modes are enabled, then change the corresponding arrays in the first lines of the code.
```
