#!/bin/bash -x

installPrefix=~/.local
installBin=$installPrefix/bin
installEtc=$installPrefix/etc/workplace
installShare=$installPrefix/share
vimrc=~/.vimrc
shrc=~/.bashrc

if [[ -f $vimrc ]]; then
    cp $vimrc $vimrc.bak
    echo vimrc '->' $vimrc '->' $vimrc.bak
fi
#cp vim/vimrc $vimrc

mkdir -p $installPrefix
mkdir -p $installBin
mkdir -p $installEtc

cp template.tex $installPrefix/etc

uname | grep "CYGWIN" &> /dev/null
if [[ $? == 0 ]]; then
    cp utils/cygwin/* $installBin
elif [[ $(uname) == "Linux" ]]; then
    cp utils/linux/* $installBin
    cp -n env/* $installEtc

    config_cmd="source $installEtc/*"
    grep -F "$config_cmd" $shrc
    if [[ "$?" == 1 ]]; then
        echo "" >> $shrc
        echo "$config_cmd" >> $shrc
    fi

    mkdir -p $installShare
    cp pipe-cl/pipe-cl $installBin
    cp pipe-cl/pipe-cl.lisp $installShare
fi
cp utils/portable/* $installBin
