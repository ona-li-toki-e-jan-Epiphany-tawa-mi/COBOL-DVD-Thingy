SOURCE_DIRECTORY = src

a.out: DVD-THING.o TERMINAL-SIZE.o
	cobc -Wall -Werror -x -o $@ $^

DVD-THING.o: ${SOURCE_DIRECTORY}/DVD-THING.CBL
	cobc -Wall -Werror -cx -o $@ $^

TERMINAL-SIZE.o: ${SOURCE_DIRECTORY}/TERMINAL-SIZE.CBL
	cobc -Wall -Werror -cm -o $@ $^
	
.PHONY: clean
clean:
	rm *.out *.o