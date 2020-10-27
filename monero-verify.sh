#!/bin/bash

# An automatic Monero Verification script written by root (setuidroot)

# Official Github Repo for this script is located at:
# https://github.com/setuidroot/monero-verify

# You need wget and gpg installed for this script to work
# To install these dependencies on Ubuntu/Debian use:
# sudo apt install wget gpg -y

# This script is currently working on Debian-based Linux Distros for
# verifying the Monero 64 bit CLI wallet (and Unofficially the GUI wallet)
# I plan to add more Monero binary architectures later.
# I will probably rewrite this entire script because it is very messy.
# All future updates to this script will be posted to my Github repo here:
#### https://github.com/setuidroot/monero-verify

# This script is licensed under GNU GPLv3... which means you can
# pretty much do whatever you want with it as long as you make your
# changes public and give me credit. Since I plan on maintaining this, if
# you have fixes, please post a PR to my official repo listed above.
# Currently this script is very messy and disjointed, but if people use it
# I will continue to work on and improve it.

# monero-verify:
# Initial Release Version: 0.0.1 (Released on 10/27/2020; mostly written 6 months prior.)

# This first release is mostly still in testing stage, but it has worked
# fine for me on Ubuntu Linux.


#### REPORTING ISSUES:
# If you encounter a problem with this script, please submit an issue here
# on Github. Make sure to include as much information about your operating
# system and about the error you have encountered so that I can fix it.
# I cannot really do anything to help you if you don't post the
# relevant information for me to work with.  Please keep that in mind.


#### USAGE:

# To use this script, you just run it:
# ./monero-verify.sh

# The script pretty much does everything else.

# This script will not let you run it as root user because it's not needed and could
# be dangerous. Just run this script as a regular user, preferably in
# your user's home directory (/home/$USER)

# You can make a new user (eg monero) and run this script as that new user:
#
# Example to make a new user (named monero):
#### sudo adduser monero
#
# Then switch to the new user (monero):
#### su - monero
#
# Now download and execute this script in the new user's home directory:
#### wget -P ~/ https://raw.githubusercontent.com/setuidroot/monero-verify/master/monero-verify.sh
#
# Finally make the script executable:
#### chmod 554 ~/monero-verify.sh
#
# Now you can run the script:
#### bash ~/monero-verify.sh





######### START_COLORS #########
# Reset
Endcolor='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White
########### END_COLORS ###########

HOME="/home/$USER"
XMRCHK="/home/$USER/monero-check"

#Root check
if [ "$EUID" = 0 ]; then
   printf $BRed'Warning'$Endcolor && printf ": You are running as root (or with sudo.) Monero does not need to run as root and thus should not run as root as a security precaution."
  echo -e "\n"
   printf $BYellow'Info'$Endcolor && printf ": This Monero integrity check script will now terminate because it should not be run with root permissions."
  echo -e "\n"
   printf $BYellow'Info'$Endcolor && printf ": Please login under a normal user account and re-run this script with non-root permissions."
  echo -e "\n"
   exit
fi

if [ "$EUID" -ne 0 ]; then
  printf $BBlue'Info'$Endcolor && printf ": You are running as Username: $USER"
 echo -e "\n"
  printf $BBlue'Info'$Endcolor && printf ": We will create a new directory (wiping over any old directory from previous script runs) located at $XMRCHK"
 echo -e "\n"
  printf $BPurple'Question'$Endcolor &&  printf ": Do you want to continue with this Monero integrity checking script?\nThis script will automatically create a new directory located at $XMRCHK and continue with downloading the Monero binaries and hashes from multiple sources to verify Monero binary integrity."
 echo -e "\n"
fi

#Check for gpg dependency
if [[ -e /usr/bin/gpg ]]; then
 printf $BGreen'GPG Dependency Detected'$Endcolor
 echo -e "\n"
else
 printf $BRed'GPG Dependency Not Detected'$Endcolor && printf ": You may need to install gpg with 'sudo apt install gpg' command, or similar command depending on your Linux Distro."
 echo -e "\n"
fi

while true; do
 read -r -p "Do you want to continue? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
       cd $HOME

#Check if ~/monero-check directory exists from a previous script run and
#delete the directory if it does exist (so we get latest binaries.)

#NOTE: if you had important files in a ~/monero-check folder, they are
#Temporarily backed up to /tmp/monero-check-backup

	if [[ -e ~/monero-check ]]; then
	 printf $BYellow'Info'$Endcolor && printf ": Deleting old files in $XMRCHK directory!" ;
	echo -e "\n" ;
#On the unlikely chance somebody had a ~/monero-check folder, move the folder
#to a backup location at /tmp/monero-check-backup. This is designed to prevent
#accidently deleting important files for somebody who picked monero-check as their directory name for important files
	 mv -n ~/monero-check /tmp/. ;
	wait ;
	 rm -rf ~/monero-check ;
	 mkdir -p ~/monero-check ;
	else
	 printf $BBlue'Info'$Endcolor && printf ": Creating new directory at $XMRCHK" ;
	echo -e "\n" ;
	 mkdir -p ~/monero-check ;
	fi

#Download binaryfate's PGP key from official Monero-project Github repo
       $(wget -O ~/monero-check/binaryfate.asc 'https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/binaryfate.asc') 
  break ;;

    [nN][oO]|[nN])
      echo -e "\n" ;
        printf $BRed'Exit'$Endcolor && printf ": script $Red"terminated"$Endcolor." ;
      echo -e "\n" ;
   exit ;;

# Deal with invalid input with a loop
	*)
	  printf $Red'Invalid Input'$Endcolor  ;
	echo -e "\n" ;
		 ;;
  esac
done

SHA="$(sha1sum ~/monero-check/binaryfate.asc | head -c 40)"
SUM="cab6ff9446d76be571e9c51325ba06d6186e5b73"


  if [ "$SHA" = "$SUM" ]; then
   printf $BGreen'Info'$Endcolor && printf ": PGP Key SHA1 checksum is valid!"
  echo -e "\n"
  elif [ "$SHA" != "$SUM" ]; then
   printf $BRed'Warning'$Endcolor && printf ": PGP Key SHA1 checksum was not found to be valid; we will check the fingerprint next."
  echo -e "\n"
  fi

FPRINT="$(gpg --keyid-format long --with-fingerprint ~/monero-check/binaryfate.asc | grep '81AC 591F E9C4 B65C 5806  AFC3 F0AF 4D46 2A0B DF92')"
RPRINT="81AC 591F E9C4 B65C 5806  AFC3 F0AF 4D46 2A0B DF92"

#Check binaryfate's PGP key against some backups I uploaded
PGPGit="$(wget -O ~/monero-check/binaryfate2.asc 'https://raw.githubusercontent.com/setuidroot/monero-verify/master/binaryfate.asc')"
PGPGist="$(wget -O ~/monero-check/binaryfate4.asc 'https://gist.githubusercontent.com/setuidroot/2bfb5e2cc20eaf2329aa1bc7fccfae1d/raw/29981548f318d95eac903a06230da0e34fe5c06e/binaryfate.asc')"
PGPPastebin="$(wget -O ~/monero-check/binaryfate3.asc 'https://pastebin.com/raw/LS1Hspvw')"
BF1="$(cat ~/monero-check/binaryfate.asc)"
BF2="$(cat ~/monero-check/binaryfate2.asc)"
FPRINT3="$(gpg --keyid-format long --with-fingerprint ~/monero-check/binaryfate3.asc | grep '81AC 591F E9C4 B65C 5806  AFC3 F0AF 4D46 2A0B DF92')"
BF4="$(cat ~/monero-check/binaryfate4.asc)"

echo -e "\n"
#Check PGPGit BF2 PGP key source against official source
 printf $BBlue'Info'$Endcolor && printf ": Now checking binaryfate's official PGP key download against several known good backup sources. This is done to verify that the official PGP key download link has not been tampered with."
 sleep 1
  echo -e "\n"
if [[ "$BF1" = "$BF2" ]]; then
 pgp2=1
 printf $BGreen'Verified'$Endcolor && printf ": Secondary Github Location PGP key verified to match official PGP key."
  echo -e "\n"
elif [[ "$BF1" != "$BF2" ]]; then
 pgp2=0
 printf $BRed'Failure'$Endcolor && printf ": Secondary Github PGP key does not match official download! This could be a problem, but let's check the official key against our other backup sources first. If you get two or more of these failures, the official key may be tampered with and you should do a manual verification."
  echo -e "\n"
fi

#Check PGPPastebin PGP fingerprint against original

if [[ "$FPRINT3" == *$RPRINT* ]]; then
 pgp3=1
 printf $BGreen'Verified'$Endcolor && printf ": Pastebin backup PGP Key Fingerprint is correctly matched with official PGP key."
  echo -e "\n"
elif [[ "$FPRINT3" != *$RPRINT* ]]; then
 pgp3=0
 printf $BRed'Failure'$Endcolor && printf ": Pastebin backup PGP Key Fingerprint does not match! This could be an abnormality. If the other two backup sources fail to match, please do a manual verification."
  echo -e "\n"
fi

#Check PGPGist (PGP key from Gist) against official PGP key source
if [[ "$BF1" = "$BF4" ]]; then
 pgp4=1
 printf $BGreen'Verified'$Endcolor && printf ": Tertiary backup PGP key verified to match the official key."
  echo -e "\n"
elif [[ "$BF1" != "$BF2" ]]; then
 pgp4=0
 printf $BRed'Failure'$Endcolor && printf ": Tertiary backup PGP key does not match the official PGP key. This could be a problem, you may want to consider doing a manual verification, especially if any of the other backup PGP keys failed to match the official key."
  echo -e "\n"
fi


if [[ "$FPRINT" == *$RPRINT* ]]; then
 pgp1=1
 printf $BGreen'Verified'$Endcolor && printf ": Official PGP Key Fingerprint is correctly matched."
elif [[ "$FPRINT" != *$RPRINT* ]]; then
 pgp1=0
 printf $BRed'Failure'$Endcolor && printf ": Official PGP Key Fingerprint does not match! This could be fault of this script due to hardcoded PGP key fingerprint values.  If the above three backup aources all verified correctly then the PGP key is probably okay."
  echo -e "\n"
fi

allpgp="$(($pgp1 + $pgp2 + $pgp3 + $pgp4))"
 echo -e "\n"
if [[ "$allpgp" = 4 ]]; then
 printf $BGreen'Validated'$Endcolor && printf ": All 4 authenticity checks have passed, the PGP key is valid."
 echo -e "\n"

elif [[ "$allpgp" = 3 ]]; then
 printf $BYellow'Warning'$Endcolor && printf ": One authenticity check has failed, but that's probably fault of one of the redundant backups. We will continue on assuming the PGP key is valid."
 echo -e "\n"

elif [[ "$allpgp" = 2 ]]; then
printf $BRed'Failure'$Endcolor && printf ": Two of the four redundant PGP key authenticity tests have failed, this is bad."
  echo -e "\n"
 printf $BYellow'Recommended'$Endcolor && printf ": I recommend you visit getmonero.org and follow their instructions for manually verifying Monero's binary releases using binaryfate's PGP key. I made this script to automate that whole process to make it easy for anybody to verify their Monero binary releases. Binaryfate's PGP key has failed 2 out of 4 authenticity tests. This isn't good, please verify the authenticity of Monero's binary releases manually."
  echo -e "\n"
 printf $BRed'Verification Failed: script terminated'$Endcolor
  echo -e "\n"
 exit

elif [[ "$allpgp" = 1 ]]; then
 printf $BRed'Failure'$Endcolor && printf ": Only one of the four redundant PGP key authenticity tests passed, this is really bad."
  echo -e "\n"
 printf $BYellow'Recommended'$Endcolor && printf ": I recommend you visit getmonero.org and follow their instructions for manually verifying Monero's binary releases using binaryfate's PGP key. I made this script to automate that whole process to make it easy for anybody to verify their Monero binary releases. Binaryfate's PGP key has failed 3 out of 4 authenticity tests. This likely means that the official PGP key that this script downloaded has been tampered with in transit, or this verification script was altered. Please verify the authenticity of Monero's binary releases manually."
  echo -e "\n"
 printf $BRed'Verification Failed: script terminated'$Endcolor
  echo -e "\n"
 exit

elif [[ "$allpgp" = 0 ]]; then
 printf $BRed'Failure'$Endcolor && printf ": All four PGP Key authenticity tests have failed! This either means Monero's signing key has changed (is no longer binaryfate's key.) Or it means the official key download was somehow tampered with."
  echo -e "\n"
 printf $BYellow'Recommended'$Endcolor && printf ": I recommend you visit getmonero.org and follow their instructions for manually verifying Monero's binary releases using binaryfate's PGP key. I made this script to automate that whole process to make it easy for anybody to verify their Monero binary releases. Binaryfate's PGP key has failed all 4 authenticity tests. This could mean Monero's signing key has changed. In the worst case, the official PGP key that this script downloaded has been tampered with in transit, or this script has been altered. Please verify the authenticity of Monero's binary releases manually."
  echo -e "\n"
 printf $BRed'Verification Failed: script terminated'$Endcolor
  echo -e "\n"
 exit

fi

#Moving on with Monero PGP key being deemed valid.
#Next we'll use the verified PGP key to verify the hashes.txt file

#Import binaryfate's authenticated PGP key
$(gpg --import ~/monero-check/binaryfate.asc)

#Get PGP signed Monero binary release hashes.txt file from getmonero.org
  $(wget -O ~/monero-check/hashes.txt 'https://getmonero.org/downloads/hashes.txt')
#Next, use binaryfate's authenticated PGP key to verify the hashes.txt file for authenticity
$(gpg --verify ~/monero-check/hashes.txt 2> /tmp/gpg-check)
gpghash=$(cat /tmp/gpg-check)
gpggood="Good signature"
gpgbad="BAD signature"

if [[ "$gpghash" == *$RPRINT* ]]; then

	if [[ "$gpghash" == *$gpggood* ]]; then
	printf $BGreen'Verified'$Endcolor && printf ": Good signature, hashes.txt file is signed by binaryfate's PGP key."
	echo -e "\n"
	elif [[ "$gpghash" == *$gpgbad* ]]; then
	printf $BRed'Invalid'$Endcolor && printf ": Bad signature, hashes.txt file has not been correctly signed by binaryfate. There could be something fishy going on here... please manually verify your monero binaries."
	echo -e "\n"
	exit
	fi

elif [[ "$gpghash" != *$RPRINT* ]]; then
 printf $BRed'Failure'$Endcolor && printf ": PGP key fingerprint did not match, script $Red"terminated"$Endcolor."
 echo -e "\n"
exit
fi
#Now we know that the hashes.txt file has not been tampered with.
#Therefore the SHA256 hashes can be checked against binary downloads to verify them.
echo -e "\n"
#Now we prompt the user asking if they want to download the CLI and/or GUI binaries

show_menu(){

    printf "\n${Cyan}=============================================${Endcolor}\n"
    printf "${BYellow} 1)${BWhite} Linux 64 bit CLI ${Endcolor}\n"
    printf "${BYellow} 2)${BWhite} (Unofficially supported) Linux 64 bit GUI ${Endcolor}\n"
  #  printf "${BYellow} 3)${BWhite} Both Linux 64 bit CLI and GUI ${Endcolor}\n"
  #  printf "${BYellow} 4)${BWhite} Linux 32 bit CLI ${Endcolor}\n"
  #  printf "${BYellow} 5)${BWhite} Linux 32 bit GUI${Endcolor}\n"
  #  printf "${BYellow} 6)${BWhite} Both Linux 32 bit CLI and GUI ${Endcolor}\n"
    printf "${Cyan}=============================================${Endcolor}\n"
    printf "Type the number corresponding to the Monero binary you want to download and verify: "
   #echo -e "\n"
    read opt
}


show_menu
while [[ $opt == $opt ]];
    do
    if [[ $opt == '' ]]; then
      #clear
      printf "${BYellow}Warning${Endcolor}: you need to pick a number!"
      show_menu;
    else
      case $opt in



########################################################################
#			      ____  _      _____
#			     |      |        |
#Number 1 (64 bit Linux CLI) |      |        |
#			     |____  |____  __|__
#
########################################################################

        [Oo][Nn][Ee]|1) printf "${BYellow}Downloading${Endcolor}: 64 bit Linux CLI Monero binary";
	echo -e "\n"
         $(wget -O ~/monero-check/linux64-cli 'https://downloads.getmonero.org/cli/linux64');
         #$(wget -P ~/monero-check/ 'https://downloads.getmonero.org/cli/monero-linux-x64-v0.15.0.5.tar.bz2');
         linux64clihash=$(sha256sum ~/monero-check/linux64-cli | head -c 64);

#Command below piped into awk to separate the hash checksum from binary filename in hashes.txt file
	linux64clihashverify=($(cat ~/monero-check/hashes.txt | grep -w $linux64clihash | awk '{print $1}'));
	 if [[ $linux64clihash == $linux64clihashverify ]]; then
	  printf $BGreen'Verified'$Endcolor && printf ": Linux 64 CLI SHA256 hash verified with hashes.txt file!";
	echo -e "\n"
	 elif [[ $linux64clihash != $linux64clihashverify ]]; then
	  printf $BRed'Failed'$Endcolor && printf ": Linux 64 CLI SHA256 hash not found in hashes.txt! ${BRed}Script Terminated${Endcolor}";
	echo -e "\n"
	  exit;
	 fi
#Next save full filename for proper hash check with secondary (github) download

	echo -e "\n";
	linux64cliname=($(cat ~/monero-check/hashes.txt | grep -w $linux64clihash | awk '{print $2}'));
	printf $BBlue'Filename is'$Endcolor && printf ": $linux64cliname";
	echo -e "\n"
#Secondary file check

#Check Github's latest release tag; this can sometimes be wrong due to slow
#Github updates binaries being posted, so we will double check with hashes.txt file
$(wget --spider 'https://github.com/monero-project/monero/releases/latest' 2>/tmp/latestCLITag)

#Get CLITag of latest release tag from Github (this is sometimes wrong.)
CLITag=$(cat /tmp/latestCLITag | grep -w tag | cut -d'/' -f8 | grep -v following)

#Double check release version tag from hashes.txt file
CLITagHashes=$(cat ~/monero-check/hashes.txt | grep monero-linux-x64- | cut -d"-" -f4 | cut -d"." -f1-4)

#Below check that latest github release tag matches hashes.txt release tag

	if [[ "$CLITag" != "$CLITagHashes" ]]; then
	 printf $BYellow'Warning'$Endcolor && printf ": The Github release tag does not match the release version found in the hashes.txt file.  This probably means that Github's releases are not up-to-date yet with the official release from getmonero.org.  We will continue without verifying the Monero binary from Github as a secondary source.  This should be okay, you can try re-running this script later to see if the Github release binary has been updated to match the official release from getmonero.org";
	echo -e "\n";
	 CLITag="$CLITagHashes";
	fi


#Below we download the Monero binary tarball from github so we can check it
#against the official download from getmonero.org and make sure they match
$(wget -P ~/monero-check/. https://github.com/monero-project/monero/releases/download/"$CLITag"/"$linux64cliname")

l64clihash=$(sha256sum ~/monero-check/$linux64cliname | head -c 64)


#Below we check to make sure the github secondary download was successful

	if [[ -f ~/monero-check/"$linux64cliname" ]]; then
	 printf $BGreen'Download Successful'$Endcolor && printf ": Secondary github download successful.";
	echo -e "\n"

#If secondary github download successful, then check hash.txt and extract
		if [[ "$l64clihash" == "$linux64clihashverify" ]]; then
   	   printf $BGreen'Verified'$Endcolor && printf ": Secondary download (from Github) matches and verifies the download from getmonero.org"
	 echo -e "\n"
	   printf $BGreen'All Verified'$Endcolor && printf ": Your Monero binaries have been authenticated and verified from multiple sources with binaryFate's official PGP key."
	 echo -e "\n"
	   printf $BBlue'Extracting Binary'$Endcolor && printf ": Your verified Monero binary $linux64cliname will now be extracted and placed in a folder called \"monero-verified\" located in your home directory."
	 echo -e "\n"
#Check if monero-verified directory already exists from a previous run
	  if [[ -e /home/$USER/monero-verified/Monero-Linux64-CLI ]]; then
	   printf $BYellow'Warning'$Endcolor && printf ": A previous Monero-Linux64-CLI Directory has been detected from a previous script run.\nDo you want to overwrite this previously verified directory located at ~/monero-verified/Monero-Linux64-CLI?\n"
	echo -e "\n"
	while true; do
	    read -r -p "Do you want want to Delete this old directory and overwrite it with the latest Monero binary? [y/N] " action
	     case "$action" in
    	      [yY][eE][sS]|[yY])
	echo -e "\n" ;
		printf $BYellow'Info'$Endcolor && printf ": overwriting old Monero-Linux64-CLI directory with the latest verified Monero binaries." ;
		mv -n /home/$USER/monero-verified/Monero-Linux64-CLI /tmp/. ;
	echo -e "\n" ;
		printf "Extracting binaries, please wait..." ;
	echo -e "\n" ;
	   mkdir -p /home/$USER/monero-verified && tar -xf ~/monero-check/$linux64cliname -C /home/$USER/monero-verified --one-top-level=Monero-Linux64-CLI --strip-components=1 ;
	    printf $BGreen'Success'$Endcolor && printf ": Your verified Monero binaries are conveniently located at /home/$USER/monero-verified\n" ;
	echo -e "\n" ;
	  break ;;

#If user doesnt want to overwrite old directory, then exit script
		[nN][oO]|[nN])
		echo -e "\n" ;
		 printf $BRed'Script Exited'$Endcolor && printf ": old Monero-Linux64-CLI directory not overwritten, nothing has been changed.\nRe-run this script if you want to verify new Monero binaries." ;
		echo -e "\n" ;
	    exit ;;
		#Invalid input loop
		*)
		  printf $Red'Invalid Input'$Endcolor  ;
	echo -e "\n" ;
		 ;;
	    esac
	done
	  else
 	   printf "Extracting binaries, please wait..."
	echo -e "\n"
	   mkdir -p /home/$USER/monero-verified && tar -xf ~/monero-check/$linux64cliname -C /home/$USER/monero-verified --one-top-level=Monero-Linux64-CLI --strip-components=1
	    printf $BGreen'Success'$Endcolor && printf ": Your verified Monero binaries are conveniently located at /home/$USER/monero-verified\n"
	echo -e "\n"
	  fi
#If github binary download hash doesn't match hashes.txt, then script fails.
		elif [[ "$l64clihash" != "$linux64clihashverify" ]]; then
	   printf $BRed'Failed'$Endcolor && printf ": Secondary hash failed to match!";
	echo -e "\n"
		exit;
		fi

#If secondary github download failed, just check primary getmonero download
#against hashes.txt file to make sure it has a valid PGP signed hash
	else
	 printf $BRed'Secondary Download Failed'$Endcolor && printf ": Failed to download the secondary Monero binary from Github.  This probably means the release hasn't been posted to Github yet; or for some reason it has failed to download."
	echo -e "\n"
	 printf $BYellow'Info'$Endcolor && printf ": Just because we failed to download the Monero binary from Github does not mean this script has failed.  We have successfully downloaded the Monero binary from the official getmonero.org website.  This secondary github download failure just means we cannot compare the two binaries from getmonero.org and the official github repo to make sure they are the same.  You may want to look into this if you are extra paranoid, but everything should be okay.  The script will continue despite this secondary download failure.  This failure does not impact this script's ability to verify the Monero binary has been signed with binaryfate's official PGP key."
	echo -e "\n"
#Re-download getmonero.org binary and update file name to match hashes.txt file name
####$(wget -O ~/monero-check/$linux64cliname 'https://downloads.getmonero.org/cli/linux64')
#^ Nope, no need do download twice from the same source, only benefit here
#would be if I used a secondary DNS resolver to verify the original source
#but a verified PGP signed hashes.txt file is more than good for now.
#####
#So, just change the name of the official downloaded Monero binary to match
#the name of the latest release binary tarball found in hashes.txt

#####
mv -n ~/monero-check/linux64-cli ~/monero-check/$linux64cliname
#####


l64clihash2=$(sha256sum ~/monero-check/$linux64cliname | head -c 64)
#Check getmonero.org binary download against hashes.txt file

	if [[ "$l64clihash2" == "$linux64clihashverify" ]]; then
   	   printf $BYellow'Info'$Endcolor && printf ": The secondary download (from Github) failed to download."
	 echo -e "\n"
	   printf $BGreen'Primary Download Verified'$Endcolor && printf ": Although we were unable to double check the Monero binary from both getmonero.org and the official github repo, the primary getmonero.org binary has been authenticated and verified to match binaryFate's official PGP key."
	 echo -e "\n"
	   printf $BBlue'Extracting Binary'$Endcolor && printf ": Your verified Monero binary $linux64cliname will now be extracted and placed in a folder called \"monero-verified\" located in your home directory."
	 echo -e "\n"
#Check to make sure Monero-Linux64-CLI doesn't exist from previous script run
  	  if [[ -e /home/$USER/monero-verified/Monero-Linux64-CLI ]]; then
	   #printf $BYellow'Previous Monero-Linux64-CLI Directory detected'$Endcolor && printf ": please delete the directory ~/monero-verified/Monero-Linux64-CLI and re-run this script!"
	#echo -e "\n"
	   #exit
#Second case statement about overwritting existing Monero-Linux64-CLI Dir
#in the event that the secondary Github download fails.
	    printf $BYellow'Warning'$Endcolor && printf ": A previous Monero-Linux64-CLI Directory has been detected from a previous script run.\nDo you want to overwrite this previously verified directory located at ~/monero-verified/Monero-Linux64-CLI?\n"
	echo -e "\n"
	while true; do
	    read -r -p "Do you want want to Delete this old directory and overwrite it with the latest Monero binary? [y/N] " action
	     case "$action" in
    	      [yY][eE][sS]|[yY])
	echo -e "\n" ;
		printf $BYellow'Info'$Endcolor && printf ": overwriting old Monero-Linux64-CLI directory with the latest verified Monero binaries." ;
		mv -n /home/$USER/monero-verified/Monero-Linux64-CLI /tmp/. ;
	echo -e "\n" ;
		printf "Extracting binaries, please wait..." ;
	echo -e "\n" ;
	   mkdir -p /home/$USER/monero-verified && tar -xf ~/monero-check/$linux64cliname -C /home/$USER/monero-verified --one-top-level=Monero-Linux64-CLI --strip-components=1 ;
	    printf $BGreen'Success'$Endcolor && printf ": Your verified Monero binaries are conveniently located at /home/$USER/monero-verified\n" ;
	echo -e "\n" ;
	  break ;;

#If user doesnt want to overwrite old directory, then exit script
		[nN][oO]|[nN]|*)
		echo -e "\n" ;
		 printf $BRed'Script Exited'$Endcolor && printf ": old Monero-Linux64-CLI directory not overwritten, nothing has been changed.\nRe-run this script if you want to verify new Monero binaries." ;
		echo -e "\n" ;
	    exit ;;
	#Below case for hitting any key by accident (invalid input.)
		*)
		  printf $Red'Invalid Input'$Endcolor ;
	echo -e "\n" ;
		 ;;
	    esac
	done
	  else
	   printf "Extracting binaries, please wait..."
	echo -e "\n"
	   mkdir -p /home/$USER/monero-verified && tar -xf ~/monero-check/$linux64cliname -C /home/$USER/monero-verified --one-top-level=Monero-Linux64-CLI --strip-components=1
	   printf $BGreen'Success'$Endcolor && printf ": Your verified Monero binaries are conveniently located at /home/$USER/monero-verified\n"
	echo -e "\n"
	  fi
#If getmonero binary sha256 hash doesn't match hashes.txt, then fail.
		elif [[ "$l64clihash2" != "$linux64clihashverify" ]]; then
	   printf $BRed'Failed'$Endcolor && printf ": The primary Monero binary download hash is incorrect!";
	echo -e "\n"
	exit;
	fi
fi

        break;
        ;;


########################################################################
#			     ____  _   _  _____
#			    |   /  |   |    |
#Number 2 (64 bit Linux GUI)|  __  |   |    |
#			    |___|  |___|  __|__
#
########################################################################

        [Tt][Ww][Oo]|2) printf "${BYellow}Downloading${Endcolor}: 64 bit Linux GUI Monero binary";
         $(wget -O ~/monero-check/linux64-gui 'https://downloads.getmonero.org/gui/linux64');
         linux64guihash=$(sha256sum ~/monero-check/linux64-gui | head -c 64);

	#Below using piped awk at end to separate hash checksum from binary filename from hashes.txt
	linux64guihashverify=($(cat ~/monero-check/hashes.txt | grep -w $linux64guihash | awk '{print $1}'));
	 if [[ $linux64guihash == $linux64guihashverify ]]; then
	  printf $BGreen'Verified'$Endcolor && printf ": Linux 64 GUI SHA256 hash verified with hashes.txt file!";
	 elif [[ $linux64guihash != $linux64guihashverify ]]; then
	  printf $BRed'Failed'$Endcolor && printf ": Linux 64 GUI SHA256 hash not found in hashes.txt! ${BRed}Script Terminated${Endcolor}";
	  exit;
	 fi
#Next save full filename for proper hash check with secondary (github) download

	echo -e "\n";
	linux64guiname=($(cat ~/monero-check/hashes.txt | grep -w $linux64guihash | awk '{print $2}'));
	mv ~/monero-check/linux64-gui ~/monero-check/$linux64guiname ;
	printf "Filename is: $linux64guiname";
	echo -e "\n"
#Secondary file check

###$(wget --spider 'https://github.com/monero-project/monero-gui/releases/latest' 2>/tmp/latestGUITag)

###GUITag=$(cat /tmp/latestGUITag | grep -w tag | cut -d'/' -f8 | grep -v following)

###$(wget -P ~/monero-check/. https://github.com/monero-project/monero-gui/releases/download/"$GUITag"/"$linux64guiname")

l64guihash=$(sha256sum ~/monero-check/$linux64guiname | head -c 64)
#okay='OK'

	if [[ "$l64guihash" == "$linux64guihashverify" ]]; then
   	  # printf $BGreen'Verified'$Endcolor && printf ": Secondary download (from Github) matches and verifies the download from getmonero.org"
	 #echo -e "\n"
	   printf $BGreen'All Verified'$Endcolor && printf ": Your Monero GUI binaries have been authenticated and verified with binaryFate's official PGP key."
	 echo -e "\n"
	   printf $BBlue'Extracting Binary'$Endcolor && printf ": Your verified Monero binary $linux64guiname will now be extracted and placed in a folder called \"monero-verified\" located in your home directory."
	 echo -e "\n"
	printf "Extracting binaries, please wait..."
	echo -e "\n"
	   mkdir -p /home/$USER/monero-verified && tar -xf ~/monero-check/$linux64guiname -C /home/$USER/monero-verified --one-top-level=Monero-Linux64-GUI --strip-components=1
	#echo -e "\n"
	   printf $BGreen'Success'$Endcolor && printf ": Your verified Monero binaries are conveniently located at /home/$USER/monero-verified/Monero-Linux64-GUI\n"
  	elif [[ "$l64guihash" != "$linux64guihashverify" ]]; then
	   printf $BRed'Failed'$Endcolor && printf ": Secondary hash failed to match!"; 
	 exit;
 	fi

        break;



        ;;

#Number 3 (64 bit Linux CLI and GUI)
       [Tt][Hh][Rr][Ee][Ee]|3) printf "${BYellow}Downloading${Endcolor}: 64 bit Linux CLI and GUI Monero binaries";
         #$(wget -O ~/monero-check/linux64-gui 'https://downloads.getmonero.org/gui/linux64');
         #$(wget -O ~/monero-check/linux64-cli 'https://downloads.getmonero.org/cli/linux64');
         #linux64guihash=$(sha256sum ~/monero-check/linux64-gui | head -c 64);
         #linux64clihash=$(sha256sum ~/monero-check/linux64-cli | head -c 64);
            show_menu;
        ;;

#Number 4 (Linux 32 bit CLI)
        [Ff][Oo][Uu][Rr]|4) printf "Linux 32 bit CLI";
         #$(wget -O ~/monero-check/linux32-cli 'https://downloads.getmonero.org/cli/linux6432');
            show_menu;
        ;;

#Number 5 (Linux ARMv8 (64 bit) CLI)
        [Ff][Ii][Vv[Ee]]|5) printf "Option 5";
      #$(wget -O ~/monero-check/linuxarm8-cli 'https://downloads.getmonero.org/cli/linuxarm8');
            show_menu;
        ;;

#Number 6 (Linux ARMv7 (32 bit) CLI)
        [Ss][Ii][Xx]|6) printf "Option 6";
      #$(wget -O ~/monero-check/linuxarm7-cli 'https://downloads.getmonero.org/cli/linuxarm7');
            show_menu;
        ;;

#Exit script if [exit] or [quit] are typed in; control+C works just as well.
        [Ee][Xx][Ii][Tt]|[Qq][Uu][Ii][Tt]) exit;
        ;;
        *)
           printf "${BYellow}Warning${Endcolor}: pick a number corresponding to the Monero binaries you want to download and verify!" ;
           show_menu;
        ;;
      esac
    fi
done
