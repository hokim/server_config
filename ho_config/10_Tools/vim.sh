#!/bin/sh

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

if [ -f ~/.vimrc ]; then
	rm -rf ~/.vimrc
fi

cp ./.vimrc_ho ~/.vimrc
