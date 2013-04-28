#!/bin/sh

function up_config()
{
    if [ -d ~/conf ]
    then
        if [ -d ~/conf/.git ]
        then
            echo "\033[0;33mYou already have installed configuration scripts. I'll update .vim\033[0m"
            cd ~/conf &&
            /usr/bin/env git pull &
        else
            echo "\033[0;33mYou already have installed configuration directory but is not git repo. I'll back it to conf.back\033[0m"
            mv ~/conf/ `~/conf.back.$(date +%Y_%m_%d_%H_%M_%S)`

            echo "\033[0;33mCloning in to my configuration scripts...\033[0m"
            cd ~ &&
            /usr/bin/env git clone https://github.com/nkwsqyyzx/conf.git &
        fi
    else
        cd ~
        echo "\033[0;33mCloning in to my vim scripts...\033[0m"
        /usr/bin/env git clone https://github.com/nkwsqyyzx/conf.git &
    fi
    wait $!
    echo "\033[0;33mBuilding self files.\033[0m"

    if [ -f ~/.bashrc ]
    then
        mv ~/.bashrc `~/.bashrc.back.$(date +%Y_%m_%d_%H_%M_%S)`
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
    echo "   if [ $# = 0 ]; then" >> ~/.bashrc
    echo "      o *.sln" >> ~/.bashrc
    echo "   else" >> ~/.bashrc
    echo "      o "$*/"*.sln" >> ~/.bashrc
    echo "   fi" >> ~/.bashrc
    echo "}" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "alias qq='nircmd.exe win close class "CabinetWClass"'" >> ~/.bashrc
    # .bashrc

    #.gitconfig
    if [ -f ~/.gitconfig ]
    then
        mv ~/.gitconfig `~/.gitconfig.back.$(date +%Y_%m_%d_%H_%M_%S)`
    fi
    cp ~/conf/.gitconfig ~/.gitconfig
    #.gitconfig

    #.vimperatorrc _vimperatorrc
    if [ -f ~/.vimperatorrc ]
    then
        mv ~/.vimperatorrc `~/.vimperatorrc.back.$(date +%Y_%m_%d_%H_%M_%S)`
    fi
    touch ~/.vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/.vimperatorrc

    if [ -f ~/_vimperatorrc ]
    then
        mv ~/_vimperatorrc `~/_vimperatorrc.back.$(date +%Y_%m_%d_%H_%M_%S)`
    fi
    touch ~/_vimperatorrc
    echo "source ~/conf/.vimperatorrc" >>~/_vimperatorrc
    #.vimperatorrc _vimperatorrc

    echo "\033[0;33mThe configure scripts is latest.Enjoy NOW!\033[0m"
}

function up_vim_scripts()
{
    if [ -d ~/.vim ]
    then
        if [ -d ~/.vim/.git ]
        then
            echo "\033[0;33mYou already have installed .vim scripts. I'll update .vim\033[0m"
            cd ~/.vim &&
            /usr/bin/env git pull &
        else
            echo "\033[0;33mYou already have installed .vim directory but is not git repo. I'll back it to .vim.back\033[0m"
            mv ~/.vim/ `~/.vim.back.$(date +%Y_%m_%d_%H_%M_%S)`

            echo "\033[0;33mCloning in to my vim scripts...\033[0m"
            /usr/bin/env git clone https://github.com/nkwsqyyzx/.vim.git &
        fi
    else
        cd ~
        echo "\033[0;33mCloning in to my vim scripts...\033[0m"
        /usr/bin/env git clone https://github.com/nkwsqyyzx/.vim.git &
    fi

    wait $!

    echo "\033[0;33mFetched the new source,handle submodules...\033[0m"
    /usr/bin/env git submodule update --init &
    wait $!
    echo "\033[0;33mCheck out master for submodules...\033[0m"
    /usr/bin/env git submodule foreach git checkout master &
    wait $!
    echo "\033[0;33mUpdating submodules...\033[0m"
    /usr/bin/env git submodule foreach git pull &
    wait $!

    echo "\033[0;33mBuild _vimrc or .vimrc...\033[0m"
    if [ -f ~/.vimrc ]
    then
        mv ~/.vimrc `~/.vimrc.back.$(date +%Y_%m_%d_%H_%M_%S)`
    fi

    touch ~/.vimrc
    echo "let g:dev_env = 'csharpdev'" >> ~/.vimrc
    echo "let g:work_directory = ''" >> ~/.vimrc
    echo "source ~/.vim/.vimrc" >> ~/.vimrc

    if [ -f ~/_vimrc ]
    then
        mv ~/_vimrc `~/_vimrc.back.$(date +%Y_%m_%d_%H_%M_%S)`
    fi

    touch ~/_vimrc
    echo "let g:dev_env = 'csharpdev'" >> ~/_vimrc
    echo "let g:work_directory = ''" >> ~/_vimrc
    echo "source ~/.vim/.vimrc" >> ~/_vimrc

    echo "\033[0;33mFinshed.Maybe you will modify your .vimrc or _vimrc to restore previous settings.Enjoy Now!\033[0m"
}

echo "\033[0;34mChecking git installed...\033[0m"
hash git >/dev/null && /usr/bin/env git status || {
  echo "git not installed"
  exit
}

up_vim_scripts
up_config
