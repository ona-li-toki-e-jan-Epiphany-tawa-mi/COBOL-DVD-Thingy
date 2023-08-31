all:
	-mkdir out
	make out/a.out
	make data

out/a.out: src/DVD-THING.CBL 
	cobc -Wall -Werror -Wno-unfinished -x -o out/a.out src/DVD-THING.CBL 

data: data/LOGO.TXT
	cp data/* out/
	
clean:
	rm -rf out/