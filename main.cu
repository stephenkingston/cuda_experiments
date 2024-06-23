#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <iostream>

__global__ void cuda_hello(){
    int i = threadIdx.x;
    int j = blockIdx.x;

    printf("Hello World from GPU!\n Thread: %d, Block: %d\n", i, j);
}

__global__ void matrix_addition(int *a, int *b, int *c, int N){
    int i = threadIdx.x;
    int j = blockIdx.x;

    // (i*N) + j is the index of the element in the 2D array
    c[i*N+j] = a[i*N+j] + b[i*N+j];
}

int main() {
    cuda_hello<<<2,2>>>(); 

    const int N = 3;
    int a[N][N], b[N][N], c[N][N];
    int *d_a, *d_b, *d_c;

    cudaMalloc((void**)&d_a, N*N*sizeof(int));
    cudaMalloc((void**)&d_b, N*N*sizeof(int));
    cudaMalloc((void**)&d_c, N*N*sizeof(int));

    // Initialize matrix a and b
    a[0][0] = 1; a[0][1] = 2; a[0][2] = 3;
    a[1][0] = 4; a[1][1] = 5; a[1][2] = 6;
    a[2][0] = 7; a[2][1] = 8; a[2][2] = 9;

    b[0][0] = 10; b[0][1] = 20; b[0][2] = 30;
    b[1][0] = 31; b[1][1] = 32; b[1][2] = 33;
    b[2][0] = 34; b[2][1] = 35; b[2][2] = 36;

    // Copy data from CPU to GPU
    cudaMemcpy(d_a, a, N*N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, N*N*sizeof(int), cudaMemcpyHostToDevice);

    // Call kernel
    matrix_addition<<<3,3>>>(d_a, d_b, d_c, N);

    cudaDeviceSynchronize();

    // Copy data from GPU to CPU
    cudaMemcpy(c, d_c, N*N*sizeof(int), cudaMemcpyDeviceToHost);

    // Print matrix a and b
    printf("Matrix A:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", a[i][j]);
        }
        printf("\n");
    }

    printf("Matrix B:\n");
    for(int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", b[i][j]);
        }
        printf("\n");
    }

    // Print result
    printf("Matrix C: (addition result) \n");
    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            printf("%d ", c[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return 0;
}