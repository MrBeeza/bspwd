#!/usr/bin/bash

# Author: Juan Rivas (aka @r1vs3c)

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Global variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
user=$(whoami)

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Exiting...\n${endColour}"
    exit 1
}

function banner(){
    echo -e "\n${turquoiseColour}              _____            ______"
    sleep 0.05
    echo -e "______ ____  ___  /______      ___  /___________________      ________ ___"
    sleep 0.05
    echo -e "_  __ \`/  / / /  __/  __ \     __  __ \_  ___/__  __ \_ | /| / /_  __ \`__ \\"
    sleep 0.05
    echo -e "/ /_/ // /_/ // /_ / /_/ /     _  /_/ /(__  )__  /_/ /_ |/ |/ /_  / / / / /"
    sleep 0.05
    echo -e "\__,_/ \__,_/ \__/ \____/      /_.___//____/ _  .___/____/|__/ /_/ /_/ /_/    ${endColour}${yellowColour}(${endColour}${grayColour}By ${endColour}${purpleColour}@r1vs3c & @ZLCube${endColour}${yellowColour})${endColour}${turquoiseColour}"
    sleep 0.05
    echo -e "                                             /_/${endColour}"
}

if [ "$user" == "root" ]; then
    banner
    echo -e "\n\n${redColour}[!] You should not run the script as the root user!\n${endColour}"
    exit 1
else
    banner
    sleep 1
    echo -e "\n\n${blueColour}[*] Installing necessary packages for the environment...\n${endColour}"
    sleep 2
    sudo pacman -Sy
    sudo pacman -S reflector
    sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    sudo pacman -S --noconfirm kitty rofi feh xclip ranger i3lock scrot wmname firejail imagemagick cmatrix htop neofetch python-pip procps fzf lsd bat pamixer flameshot
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install some packages!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi

    echo -e "\n${blueColour}[*] Installing pywal...\n${endColour}"
    sleep 2

    if ! sudo pacman -Qi pywal &>/dev/null; then

     python -m venv ~/pywal-venv
     source ~/pywal-venv/bin/activate
     pip install pywal
    else

     sudo pacman -S --noconfirm pywal
    fi

    echo -e "\n${blueColour}[*] Starting installation of necessary dependencies for the environment...\n${endColour}"
    sleep 0.5

    echo -e "\n${purpleColour}[*] Installing necessary dependencies for bspwm...\n${endColour}"
    sleep 2
    sudo pacman -S --noconfirm xcb-util xcb-util-keysyms xcb-util-wm sxhkd xdo git

    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install some dependencies for bspwm!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi


    echo -e "\n${blueColour}[*] Starting installation of the tools...\n${endColour}"
    sleep 0.5
    mkdir ~/tools && cd ~/tools

    echo -e "\n${purpleColour}[*] Installing bspwm...\n${endColour}"
    sudo pacman -S --noconfirm bspwm
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install bspwm!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi
    cd ..

    echo -e "\n${purpleColour}[*] Installing sxhkd...\n${endColour}"
    sleep 2
    git clone https://github.com/baskerville/sxhkd.git
    cd sxhkd
    make -j$(nproc)
    sudo make install
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install sxhkd!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi
    cd ..

    echo -e "\n${purpleColour}[*] Installing polybar...\n${endColour}"
    sleep 2
    sudo pacman -S --noconfirm polybar
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install polybar!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi

    cd ../../

    echo -e "\n${purpleColour}[*] Installing picom...\n${endColour}"
    sleep 2
    yay -S --noconfirm picom-git

    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install picom!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi
    cd ..

    echo -e "\n${purpleColour}[*] Installing Oh My Zsh and Powerlevel10k for user $user...\n${endColour}"
    sleep 2
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install Oh My Zsh and Powerlevel10k for user $user!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi

    echo -e "\n${purpleColour}[*] Installing Oh My Zsh and Powerlevel10k for user root...\n${endColour}"
    sleep 2
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
    if [ $? != 0 ] && [ $? != 130 ]; then
        echo -e "\n${redColour}[-] Failed to install Oh My Zsh and Powerlevel10k for user root!\n${endColour}"
        exit 1
    else
        echo -e "\n${greenColour}[+] Done\n${endColour}"
        sleep 1.5
    fi

    echo -e "\n${blueColour}[*] Starting configuration of fonts, wallpaper, configuration files, .zshrc, .p10k.zsh, and scripts...\n${endColour}"
    sleep 0.5

    echo -e "\n${purpleColour}[*] Configuring fonts...\n${endColour}"
    sleep 2
    if [[ -d "$fdir" ]]; then
        cp -rv $dir/fonts/* $fdir
    else
        mkdir -p $fdir
        cp -rv $dir/fonts/* $fdir
    fi
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Configuring wallpaper...\n${endColour}"
    sleep 2
    if [[ -d "~/Wallpapers" ]]; then
        cp -rv $dir/wallpapers/* ~/Wallpapers
    else
        mkdir ~/Wallpapers
        cp -rv $dir/wallpapers/* ~/Wallpapers
    fi
    wal -nqi ~/Wallpapers/archkali.png
    sudo wal -nqi ~/Wallpapers/archkali.png
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Configuring configuration files...\n${endColour}"
    sleep 2
    cp -rv $dir/config/* ~/.config/
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Configuring the .zshrc and .p10k.zsh files...\n${endColour}"
    sleep 2
    cp -v $dir/.zshrc ~/.zshrc
    sudo ln -sfv ~/.zshrc /root/.zshrc
    cp -v $dir/.p10k.zsh ~/.p10k.zsh
    sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Configuring scripts...\n${endColour}"
    sleep 2
    sudo cp -v $dir/scripts/whichSystem.py /usr/local/bin/
    cp -rv $dir/scripts/*.sh ~/.config/polybar/shapes/scripts/
    touch ~/.config/polybar/shapes/scripts/target
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Configuring necessary permissions and symbolic links...\n${endColour}"
    sleep 2
    chmod -R +x ~/.config/bspwm/
    chmod +x ~/.config/polybar/launch.sh
    chmod +x ~/.config/polybar/shapes/scripts/*
    sudo chmod +x /usr/local/bin/whichSystem.py
    sudo chmod +x /usr/local/bin/screenshot
    sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
    sudo chown root:root /usr/local/share/zsh/site-functions/_bspc
    sudo mkdir -p /root/.config/polybar/shapes/scripts/
    sudo touch /root/.config/polybar/shapes/scripts/target
    sudo ln -sfv ~/.config/polybar/shapes/scripts/target /root/.config/polybar/shapes/scripts/target
    cd ..
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${purpleColour}[*] Removing repository and tools directory...\n${endColour}"
    sleep 2
    rm -rfv ~/tools
    rm -rfv $dir
    echo -e "\n${greenColour}[+] Done\n${endColour}"
    sleep 1.5

    echo -e "\n${greenColour}[+] Environment configured :D\n${endColour}"
    sleep 1.5

    while true; do
        sudo reboot
    done
fi
