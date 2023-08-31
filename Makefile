# TODO Make this condense everything into a single executable.

all:
	make a.out
	make TERMINAL-SIZE.so

a.out: src/DVD-THING.CBL 
	cobc -Wall -Werror -x -o a.out src/DVD-THING.CBL 

TERMINAL-SIZE.so: src/TERMINAL-SIZE.CBL
	cobc -Wall -Werror -m -o TERMINAL-SIZE.so src/TERMINAL-SIZE.CBL
	
clean:
	rm *.out *.so