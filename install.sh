#!/bin/sh -x

installPrefix=~/.local
installBin=$installPrefix/bin
installEtc=$installPrefix/etc
vimrc=~/.vimrc
shrc=~/.zshrc

if [[ -f $vimrc ]]; then
    cp $vimrc $vimrc.bak
    echo vimrc '->' $vimrc '->' $vimrc.bak
fi
cp vim/vimrc $vimrc

mkdir $installPrefix
mkdir $installBin
mkdir $installEtc

if uname | grep "CYGWIN" &> /dev/null; then
    cp utils/cygwin/* $installBin
elif [[ $(uname) == "Linux" ]]; then
    cp utils/linux/* $installBin
    cp -n env/shell.cfg $installEtc

    config_cmd="source $installEtc/shell.cfg"
    grep "$config_cmd" $shrc
    if [[ "$?" == 1 ]]; then
        echo "" >> $shrc
        echo "$config_cmd" >> $shrc
    fi
fi
cp utils/portable/* $installBin
