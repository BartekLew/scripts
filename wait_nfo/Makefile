compile=gcc -Wall -pedantic -std=c99 -g

wait_nfo: wait_nfo.c
	$(compile) wait_nfo.c -o wait_nfo

install: wait_nfo
	cp wait_nfo ~/.local/bin
