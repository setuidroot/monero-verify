# monero-verify
Monero-verify is a Linux (Bash) shell script that automatically downloads and verifies the latest Monero binary releases using multiple sources for redundancy to make certain the Monero release you chose to download is legitimate.  After it validates the Monero release, it automatically extracts the archive and puts your monero release binaries in a folder located at ~/monero-verified/*/

This script is very simple to use and it guides you with detailed informational prompts along the way.  I designed this script with many complexities in checking everything from multiple sources to ensure Monero binary integrity, but I also designed it to be incredibly easy to use, making it easy for people with limited knowledge on these subjects to be able to download and ensure the integrity of their Monero release binaries with just a few clicks using this script.

**How To Use This Script**:

This script runs well on Ubuntu Linux (or any Debian-based Linux Distro.)  For this guide, we will just assume Ubuntu Linux (but Debian or any derivative works just as well.)  You will need the dependencies *wget* and *gpg* installed on Ubuntu.  First you need to open the Terminal window.  Everything about using this script is done inside the Terminal window.

*Installing Dependencies*:

````
sudo apt install wget gpg
````

Now you simply download this script from github and run it in your Terminal window, steps to do this are listed below.

You must run this script as a user (not as root.)  You can use your default username, or you can create a new user (e.g. monero) to run this script in the new user's home directory.


===== *OPTIONAL SECTION* =====

Here we have the *Optional Step* of creating a new user for running this script.  We'll call this user *monero*, but you can pick any username you want.  To make a new user named monero:

````
sudo adduser monero
````

Then switch to the new "monero" user account with:

````
su - monero
````

===== *END OPTIONAL SECTION* =====


**Download and Run this Script**:

To run this script, we must first download it with this command:

````
wget -P ~/ https://raw.githubusercontent.com/setuidroot/monero-verify/master/monero-verify.sh
````

Next, we make this script executable:

````
chmod 554 ~/monero-verify.sh
````

Finally, you run this script:

````
bash ~/monero-verify.sh
````

Just follow the script's prompts in your Terminal window and you will very quickly and easily have your Monero binaries downloaded and verified as legitimate.  This script is actually very simple to use and it does most of the work for you.

*Currently this script ***only supports*** the ***64 bit Linux CLI*** and ***64 bit Linux GUI*** Monero binary downloads.*  More Monero release downloads and CPU architectures are planned to be added to this script in the future.

If you have any problems with this script, please create an issue here on Github and be sure to include as much information about your operating system and the nature of the problem you've encountered so that I can fix the issue.

If you have any questions, you can just post those here on Github issues as well and I will answer them when I'm around.




**Details about how this script works**:

The monero-verify script works by first downloading Monero's official PGP public signing key (binaryfate.asc) from **multiple sources**.  This script uses multiple sources to *verify* that the official PGP signing key has not been tampered with from any single source.  The redundancy in checking the validity of the PGP signing key is important because this is the PGP public key that the [Monero-Project](https://github.com/monero-project/monero) uses to sign its official releases.


After the script has verified Monero's PGP public key, it proceeds to download Monero's official [hashes.txt](https://getmonero.org/downloads/hashes.txt) file.  The hashes.txt file is the official PGP signed file that Monero puts out with each new Monero release.  The hashes.txt file contains a list of the names and corresponding SHA256 hashes of the latest Monero binary release archives.  This hashes.txt file was signed using Monero's PGP private key (the private keypair of binaryfate.asc.)  This allows us to verify that the hashes.txt file we download has **not** been altered in any way since it was signed by the Monero devs.


The script uses Monero's public PGP key (which it has already verified from multiple sources) to check and make sure that the hashes.txt file has not been altered since it was signed.  If the hashes.txt had been altered, even if one space was added to it, then the PGP signature would not match with Monero's PGP signing key and the script would fail with a detailed warning on why it failed.


The script does all of the actions mentioned above when it is first run.  It creates a directory called monero-check where it puts the 4 redundant copies of Monero's PGP key (binaryfate.asc) and the latest official hashes.txt file in this directory.  If everything is verified correctly, the script will continue to a prompt asking you to put in a number corresponding to the Monero release binary that you want the script to download and verify.  Currently the only 2 options are for the 64 bit Linux CLI release and the 64 bit Linux GUI release.  Type in either number 1 (for CLI) or 2 (for GUI) and hit enter for the script to continue on with the Monero binary download.


After you make your download selection, the script will continue on with downloading the Monero binary you selected from two different official sources.  It downloads the official Monero release binary from getmonero.org and then downloads the same Monero release binary from Monero's official Github repo so the script can check that the download from both sources is the same.  **Note**: This is an unnecessarily paranoid step because the script is able to verify or invalidate the Monero binary release downloaded from either source with the already authenticated hashes.txt file.  Currently this script only double checks the release download of the 64 bit Linux CLI from Github.  The 64 bit Linux GUI download and verification works just fine with the current release of this script, but it does not do the unnecessary double download from Github; it just downloads and *verifies* the official release from getmonero.org.  The Github download presents a challenge for the script because sometimes the Monero release isn't present or isn't updated on Github yet, while the official release from getmonero.org should be treated as canonical anyways.  Future versions of this script probably will not bother downloading the Monero release from Github as well.


Once the script has downloaded the official Monero release binary archive, it proceeds with checking the SHA256 hash of that downloaded archive against the known good SHA256 hash in the verified hashes.txt file.  If the SHA256 hash of the downloaded Monero release archive matches the validated SHA256 in the hashes.txt file, then the script has confirmed the authenticity of the downloaded Monero release archive to be legitimate.  At this point the script will give you a Terminal printout saying that the download has been verified and it will continue with extracting the Monero release archive into a folder called monero-verified located in your user's home directory,' ~/monero-verified.  You will now find your verified Monero release binaries at ~/monero-verified/*/


This script will guide you through the automated process with informational printouts in your Terminal window along the way.  If any of the redundant PGP key download sources are altered or unavailable, it will tell you this; if 2 or more of the redundant PGP keys fail, the script will fail detailing the reason why it failed.  By the time you see the download selection screen, you should also see 4 green "*verified*" printouts and a green "*Validated*" printout as shown in [this screenshot.](https://raw.githubusercontent.com/setuidroot/monero-verify/master/monero-verify-ExampleScreenshot.png)  This means the script has already verified Monero's PGP signing key and the hashes.txt file.
