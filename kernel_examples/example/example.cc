int example(int N, int M,  bool secret){
    int sum = 0;
    for (int i = 0; i < N; i++){
        for(int j = 0; j < M; j++){
            if(secret){
                sum += i;
            }
            else{
                sum += j;
            }
        }
    }
    return sum;
}

int main (){
    example(10, 12, false);
    return 0;
}