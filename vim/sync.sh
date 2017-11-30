#/bin/bash -x

localBin="$HOME/.local/bin"
places="$HOME/.vimrc vimrc"

if [[ ! -f "$localBin/synch.sh" ]]; then
    mkdir -p "$localBin"
    cp sync.sh "$localBin/sync.sh"
fi

diff $places
if [ "$?" == "1" ]; then
    if [ $(ls -t $places | head -n1) == vimrc ] ; then
		cp vimrc $HOME/.vimrc
	else
		cp $HOME/.vimrc vimrc
    fi
fi
