FLAGS = `llvm-config --cxxflags --ldflags --system-libs --libs all` -O0 -g3 

all: printer main


printer: printer.cc
	g++ printer.cc -o printer $(FLAGS)

main: loop_summary.cc control_variable.cc main.cc
	g++ loop_summary.cc control_variable.cc main.cc -o main $(FLAGS)

clean:
	rm -f printer main 