FLAGS = `llvm-config --cxxflags --ldflags --system-libs --libs all` -O0 -g3 
SRC = $(wildcard *.cc)

all: main

main: $(SRC)
	g++ $(SRC) -o main $(FLAGS)

clean:
	rm -f main 