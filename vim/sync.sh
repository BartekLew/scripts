#!/bin/bash

repo="$PWD"
localBin="$HOME/.local/bin"
places="$HOME/.vimrc $repo/vimrc"

if [[ ! -f "$localBin/sync.sh" ]]; then
    mkdir -p "$localBin"
    sed 's#repo="$PWD"#repo="'$repo'"#' sync.sh > "$localBin/sync.sh"
    chmod +x "$localBin/sync.sh"
fi

diff $places
if [ "$?" == "1" ]; then
    if [ $(ls -t $places | head -n1) == vimrc ] ; then
            cp $repo/vimrc $HOME/.vimrc
	else
            cp $HOME/.vimrc $repo/vimrc
    fi
fi
