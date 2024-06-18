#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <iostream>

__global__ void cuda_hello(){
    int i = threadIdx.x;
    int j = blockIdx.x;

    printf("Hello World from GPU!\n Thread: %d, Block: %d\n", i, j);
}

int main() {
    cuda_hello<<<3,10>>>(); 
    return 0;
}