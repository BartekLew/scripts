#!/bin/sh -x

places="$HOME/.vimrc vimrc"

diff $places
if [ "$?" == 1 ]; then
    if [ `ls -t $places | tail -n1` == 'vimrc' ] ; then
		cp vimrc $HOME/.vimrc
	else
		cp $HOME/.vimrc vimrc
    fi
fi
