#!/bin/sh

installPrefix=~/.local
installBin=$installPrefix/bin
vimrc=~/.vimrc

if [[ -f $vimrc ]]; then
    cp $vimrc $vimrc.bak
    echo vimrc '->' $vimrc '->' $vimrc.bak
fi
cp vim/vimrc $vimrc

mkdir $installPrefix
mkdir $installBin

if uname | grep "CYGWIN" &> /dev/null; then
    cp utils/cygwin/* $installBin
elif [[ $(uname) == "Linux" ]]; then
    cp utils/linux/* $installBin
fi

cp utils/portable/* $installBin
