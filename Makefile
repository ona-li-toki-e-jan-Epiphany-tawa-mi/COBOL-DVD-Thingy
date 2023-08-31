a.out: src/DVD-THING.CBL 
	cobc -Wall -Werror -x -o a.out src/DVD-THING.CBL 
	
clean:
	rm *.out