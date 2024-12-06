int main(){
    int control_variable = 0;
    for(int i = 0; i < 10; i++){
        control_variable += i;
    }
    if(control_variable > 10){
        return 0;
    }
    else {
        return 1;
    }
}