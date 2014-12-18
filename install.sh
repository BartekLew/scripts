#!/bin/sh

installPrefix=~/.local
installBin=$installPrefix/bin

cp vim/vimrc ~/.vimrc

mkdir $installPrefix
mkdir $installBin
cp git/* $installBin
