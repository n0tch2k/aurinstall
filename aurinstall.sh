#!/bin/bash

# aurinstall - a small AUR helper for Archlinux users.
# written by n0tch2k (https://github.com/n0tch2k)

# VARIABLES
PACKAGE=$1
col_ok="\e[1;32m"
col_fail="\e[1;31m"
col_info="\e[0;34m"
col_end="\e[0m"

function search_and_dl {
	echo -e "$col_info[~]$col_end Searching package: $PACKAGE"
	
	# Shorten package name to first two letters, start download
	DIR=${PACKAGE:0:2}
	
	wget -q --spider https://aur.archlinux.org/packages/$DIR/$PACKAGE/$PACKAGE.tar.gz
	status=$?

	if [[ "$status" -eq "0" ]]
		then
			echo -e "$col_ok[+]$col_end Starting download."
			wget https://aur.archlinux.org/packages/$DIR/$PACKAGE/$PACKAGE.tar.gz -q --show-progress
			extract
		else
			echo -e "$col_fail[!]$col_end Could not find package: $PACKAGE"
			exit 1
	fi

}

function extract {
	echo -e "$col_info[~]$col_end Extracting package: $PACKAGE"
	tar -xvzf $PACKAGE.tar.gz > /dev/null
	rm $PACKAGE.tar.gz

	cd $PACKAGE

	echo -en "$col_info[?]$col_end Open PKGBUILD with Vim? (Y/n) " 
		read antwort in
			case "$antwort" in
				Yes|yes|Y|y|"") 
					vim PKGBUILD
					install
				;;
				No|no|N|n)
					install
				;;
				*)
				echo -e "$col_fail[!]$col_end Unexpected answer."
				;;
			esac
}

function install {
	echo -e "$col_ok[+]$col_end Starting makepkg."
	makepkg -cs
	echo -e "$col_info[~]$col_end You can now use sudo pacman -U to install the package."
}

# MAIN
if [ $1 ]
	then
		search_and_dl
	else
		echo -e "$col_fail[!]$col_end Usage: ./aurinstall \$package"
fi

#function clean{
#}