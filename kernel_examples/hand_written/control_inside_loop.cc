int main(){
    int control_variable = 0;
    int workload = 0;
    for(int i = 0; i< 10; i++){
        if (control_variable == 0) {
            workload += 1;
        }
        else{
            workload += 2;
        }
    }
    return 0;
}