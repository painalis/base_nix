#!/bin/bash
function ask()
{
    while true; do
        read -p "$2" choice
        case $choice in
            [Yy]* )
                declare -g "$1=true"
                break;
                ;;
            [Nn]* )
                declare -g "$1=false"
                break;
                ;;
            *)
                echo "Please enter y or n"
                ;;
        esac
    done
}

ask ZSH "Install ZSH environment? (y/n):"
ask USEFUL "Install Useful stuff (tmux and google chrome)? (y/n):"
ask RC "Overwrite rc files? (y/n):"
ask CTF "Install CTF environment? (y/n):"
ask QIRA "Install QIRA environment? (y/n):"


if $USEFUL; then
    echo "USEFUL"
    ./useful.sh
fi

if $RC; then
    echo "RC"
    # Copy rc file
    sudo apt-get install -y vim
    cp ./dotfiles/gitconfig ~/.gitconfig
    cp ./dotfiles/tmux.conf ~/.tmux.conf
    cp ./dotfiles/vimrc ~/.vimrc
    cp ./dotfiles/bashrc ~/.bashrc
    cp ./dotfiles/pythonrc ~/.pythonrc
    cp ./dotfiles/screenrc ~/.screenrc

    # Install vim plugins
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

if $CTF; then
    echo "CTF"
    ./ctf_tools.sh
fi

if $QIRA; then
    # Install qira
    # TOFIX for i386
    git clone https://github.com/BinaryAnalysisPlatform/qira.git ~/qira
    sudo wget -O /usr/share/keyrings/ubuntu-archive-keyring.gpg http://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg
    ~/qira/install.sh
    ~/qira/fetchlibs.sh
fi

if $ZSH; then
    sudo apt-get -y install zsh
    sudo apt-get -y install fortune cowsay
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    echo "Remember to run: chsh -s $(which zsh)"
fi

