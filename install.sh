#!/bin/bash

########################################################################################################
# Script Dependencies
########################################################################################################
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

########################################################################################################
# Update packages list and update system
########################################################################################################
sudo apt update
sudo apt upgrade -y

########################################################################################################
# Installing Essential Programs 
########################################################################################################
sudo apt install curl wget unzip zsh nautilus wireguard rofi redshift redshift-gtk -y

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ProtonVPN
cd $builddir
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.6_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop -y
# sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator # Optional
rm ./protonvpn-stable-release_1.0.6_all.deb

# Install Brave Browser
cd $builddir
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

# Install Spotify
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

########################################################################################################
# Install Fonts
########################################################################################################
sudo apt install fonts-terminus

# Set the font to Terminus Fonts
setfont /usr/share/consolefonts/Uni3-TerminusBold24x12.psf.gz

cd $builddir 
sudo apt install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/DejaVuSansMono.zip
unzip DejaVuSansMono.zip -d /home/$username/local/share/fonts/DejaVuSansMono
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip
unzip Meslo.zip -d /home/$username/local/share/fonts/Meslo
chown $username:$username /home/$username/local/share/fonts

# Reloading Font
fc-cache -vf
cd $builddir
rm ./DejaVuSansMono.zip ./Meslo.zip

########################################################################################################
# Install Bibata cursor
########################################################################################################
cd $builddir
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz
tar -xvf Bibata-Modern-Classic.tar.xz 
mv Bibata-* ~/.local/share/icons/
cd $builddir
rm ./Bibata-Modern-Classic.tar.xz

########################################################################################################
# Install config files & wallpaper
########################################################################################################
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/local/share/fonts
mkdir -p /home/$username/local/share/icons
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
cp -R dothome/* /home/$username/
cp -R dotconfig/* /home/$username/.config/
cp bg.jpeg /home/$username/Pictures/backgrounds/
chown -R $username:$username /home/$username

########################################################################################################
# Enable graphical login and change target from CLI to GUI
########################################################################################################
#systemctl enable lightdm
#systemctl set-default graphical.target

########################################################################################################
# Enable wireplumber audio service
########################################################################################################

#sudo -u $username systemctl --user enable wireplumber.service

########################################################################################################
# DWM Setup
########################################################################################################
#git clone https://github.com/ChrisTitusTech/dwm-titus
#cd dwm-titus
#make clean install
#cp dwm.desktop /usr/share/xsessions
#cd $builddir
