#!/bin/sh

function up_config()
{
    if [ -d ~/conf ]
    then
        if [ -d ~/conf/.git ]
        then
            echo "You already have installed configuration scripts. I'll update configuration"
            cd ~/conf &&
            /usr/bin/env git pull &
        else
            echo "You already have installed configuration directory but is not git repo. I'll back it to conf.back"
            mv ~/conf/ ~/.back.conf.$(date +%Y.%m.%d.%H.%M.%S)

            echo "Cloning in to my configuration scripts..."
            cd ~ &&
            /usr/bin/env git clone https://github.com/nkwsqyyzx/conf.git &
        fi
    else
        cd ~
        echo "Cloning in to my vim scripts..."
        /usr/bin/env git clone https://github.com/nkwsqyyzx/conf.git &
    fi
    wait $!
    echo "Building self files."

    if [ -f ~/.bashrc ]
    then
        mv ~/.bashrc ~/.back.bashrc.$(date +%Y.%m.%d.%H.%M.%S)
    fi

    touch ~/.bashrc

    # .bashrc
    echo "source ~/conf/.bashrc" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "# aliases for working project." >> ~/.bashrc
    echo "alias cw='cd /cygdrive/e/win8/Sipo/trunk'" >> ~/.bashrc
    echo "alias ow='o *.sln'" >> ~/.bashrc
    echo "alias op='o ..'" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "alias ow='ow_'" >> ~/.bashrc
    echo "function ow_ () {" >> ~/.bashrc
    echo "   if [ \$# = 0 ]; then" >> ~/.bashrc
    echo "      o *.sln" >> ~/.bashrc
    echo "   else" >> ~/.bashrc
    echo "      o "\$*/"*.sln" >> ~/.bashrc
    echo "   fi" >> ~/.bashrc
    echo "}" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "alias qq='nircmd.exe win close class "CabinetWClass"'" >> ~/.bashrc
    # .bashrc

    #.gitconfig
    if [ -f ~/.gitconfig ]
    then
        mv ~/.gitconfig ~/.back.gitconfig.$(date +%Y.%m.%d.%H.%M.%S)
    fi
    cp ~/conf/.gitconfig ~/.gitconfig
    #.gitconfig

    #.vimperatorrc _vimperatorrc
    if [ -f ~/.vimperatorrc ]
    then
        mv ~/.vimperatorrc ~/.back.vimperatorrc.$(date +%Y.%m.%d.%H.%M.%S)
    fi
    touch ~/.vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/.vimperatorrc

    if [ -f ~/_vimperatorrc ]
    then
        mv ~/_vimperatorrc ~/.back._vimperatorrc.$(date +%Y.%m.%d.%H.%M.%S)
    fi
    touch ~/_vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/_vimperatorrc
    #.vimperatorrc _vimperatorrc

    echo "The configure scripts is latest.Enjoy NOW!"
}

function up_vim_scripts()
{
    if [ -d ~/.vim ]
    then
        if [ -d ~/.vim/.git ]
        then
            echo "You already have installed .vim scripts. I'll update .vim"
            cd ~/.vim &&
            /usr/bin/env git pull &
        else
            echo "You already have installed .vim directory but is not git repo. I'll back it to .vim.back"
            mv ~/.vim/ ~/.back.vim.$(date +%Y.%m.%d.%H.%M.%S)

            echo "Cloning in to my vim scripts..."
            /usr/bin/env git clone https://github.com/nkwsqyyzx/.vim.git &
        fi
    else
        cd ~
        echo "Cloning in to my vim scripts..."
        /usr/bin/env git clone https://github.com/nkwsqyyzx/.vim.git &
    fi

    wait $!

    echo "Fetched the new source,handle submodules..."
    /usr/bin/env git submodule update --init &
    wait $!
    echo "Check out master for submodules..."
    /usr/bin/env git submodule foreach git checkout master &
    wait $!
    echo "Updating submodules..."
    /usr/bin/env git submodule foreach git pull &
    wait $!

    echo "Build _vimrc or .vimrc..."
    if [ -f ~/.vimrc ]
    then
        mv ~/.vimrc ~/.back.vimrc.$(date +%Y.%m.%d.%H.%M.%S)
    fi

    touch ~/.vimrc
    echo "let g:dev_env = 'csharpdev'" >> ~/.vimrc
    echo "let g:work_directory = ''" >> ~/.vimrc
    echo "source ~/.vim/.vimrc" >> ~/.vimrc
    dos2unix ~/.vimrc

    if [ -f ~/_vimrc ]
    then
        mv ~/_vimrc ~/.back._vimrc.$(date +%Y.%m.%d.%H.%M.%S)
    fi

    touch ~/_vimrc
    echo "let g:dev_env = 'csharpdev'" >> ~/_vimrc
    echo "let g:work_directory = ''" >> ~/_vimrc
    echo "source ~/.vim/.vimrc" >> ~/_vimrc

    echo "Finshed.Maybe you will modify your .vimrc or _vimrc to restore previous settings.Enjoy Now!"
}

up_vim_scripts &
wait $!
up_config &
wait $!
