# peas-updater

Simple bash script that automatically downloads and updates the scripts/binaries from the PEAS suite with their latest releases. Also stores the scripts/binaries in a easy-to-access folder structure for quick use in your pentests and CTFs.

By default will download and update all Linux and Windows scripts/binaries. You can adjust which scripts/binaries will be downloaded and updated using flags.

## Usage  

```bash
./update-peas.sh [OPTIONS]

Options:
	-h, --help
		Displays help information.
	-g, --git-check
		Enables downloading and updating scripts ONLY if the peass-ng git repo has been updated since the last time this bash script was run. Requires git. 
	-l, --linux-only
		Downloads and updates only Linux scripts/binaries (linpeas). Can't be used in conjuction with -w or --windows-only.
	-w, --windows-only
		Downloads and updates only Windows scripts/executables (winpeas). Can't be used in conjuction with -l or --linux-only.
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
