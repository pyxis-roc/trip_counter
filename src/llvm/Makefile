FLAGS = `llvm-config --cxxflags --ldflags --system-libs --libs all` -O0 --debug

all: printer loops


printer: printer.cc
	clang++ printer.cc -o printer $(FLAGS)

loops:	loops.cc
	clang++ loops.cc -o loops $(FLAGS)

clean:
	rm -f printer loops 