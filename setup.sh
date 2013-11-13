#!/bin/sh



# ----------------------------------------initialize----------------------------------------
__lower_case(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

__sys_info(){
    SYS_OS=$(__lower_case $(uname))
    SYS_KERNEL=$(uname -r)
    SYS_MACH=$(uname -m)

    # TODO.fix me when in mingw32 and other linux.
    if [[ "${SYS_OS}" == mingw32_nt* ]]; then
        SYS_OS=windows_mingw
    elif [[ "${SYS_OS}" == cygwin_nt* ]]; then
        SYS_OS=windows_cygwin
    elif [[ "${SYS_OS}" = "darwin" ]]; then
        SYS_OS=mac
    else
        SYS_OS=linux
    fi
}
__sys_info
# ----------------------------------------end----------------------------------------





command_exists () {
    command -v "$1" &> /dev/null;
}

if command_exists nircmd ; then
    echo "you have nircmd installed."
else
    echo "you don't have nircmd in your path.please check it out or else you can't use qq to close all windows."
fi

function build_bashrc()
{
    cat >~/.bashrc <<EOF
    source ~/conf/.bashrc

    # aliases for working project.
    alias cw='cd /cygdrive/drive/path/to/your/favorite/path'
    alias ow='o *.sln'
    alias op='o ..'

    alias ow='ow_'
    function ow_ () {
    if [ $# = 0 ]; then
        o *.sln
    else
        o $*/*.sln
    fi
}

alias qq='nircmd.exe win close class CabinetWClass'
EOF
}

back_dir=back_$(date +%Y_%m_%d_%H_%M_%S)
function ensure_back_dir()
{
    if [ ! -d ~/$back_dir ]
    then
        mkdir ~/$back_dir
    fi
}

function backupoldfile()
{
    for var in "$@"
    do
        echo "\$var is $var"
        if [ -d "$var" ] || [ -f "$var" ]
        then
            ensure_back_dir
            mv "$var" ~/$back_dir/$var
            echo "$var moved to $back_dir/"
        fi
    done
}

cd ~
backupoldfile .bashrc .zshrc .zsh_alias
backupoldfile .vim/ .vimrc _vimrc _vimperatorrc .vimperatorrc
backupoldfile conf/ .gitconfig

function getConfigurations()
{
    cd ~
    echo "Cloning in to my vim scripts..."
    /usr/bin/env git clone https://github.com/nkwsqyyzx/conf.git &
    wait $!
    echo "Building self files."

    # .bashrc
    build_bashrc
    # .bashrc

    #.gitconfig
    cp ~/conf/.gitconfig ~/.gitconfig
    #.gitconfig

    #.vimperatorrc _vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/.vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/_vimperatorrc
    #.vimperatorrc _vimperatorrc

    echo "The configure scripts is latest.Enjoy NOW!"
}

function getVimScripts()
{
    cd ~
    echo "Cloning in to my vim scripts..."
    /usr/bin/env git clone https://github.com/nkwsqyyzx/.vim.git & wait $!

    echo "Fetched the new source,handle submodules..."
    cd ~/.vim
    /usr/bin/env git submodule update --init --recursive & wait $!

    echo "Build _vimrc or .vimrc..."
    echo "let g:dev_env = 'csharpdev'" >> ~/.vimrc
    echo "let g:work_directory = '/path/to/your/favorate/project/path'" >> ~/.vimrc
    echo "source ~/.vim/.vimrc" >> ~/.vimrc
    echo "au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent" >> ~/.vimrc
    dos2unix ~/.vimrc

    cp ~/.vimrc ~/_vimrc

    echo "Finshed.Maybe you will modify your .vimrc or _vimrc to restore previous settings.Enjoy Now!"
}

getConfigurations & wait $!
getVimScripts & wait $!
