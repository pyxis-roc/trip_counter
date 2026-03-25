#include <iostream>

extern "C" {
    void print_counter(char* block_ID, char* name, long N){
        std::cout<<block_ID<<' '<<name<<' '<<N<<std::endl;
    }
}