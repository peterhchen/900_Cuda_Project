
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
__global__ void unique_idx_calc_threadIdx(int *input)
{
    int tid = threadIdx.x;
    printf("threadIdx: %d, value: %d\n", tid, input[tid]);
}
__global__ void unique_gid_calculation(int* input)
{
    int tid = threadIdx.x;
    int offset = blockIdx.x * blockDim.x;
    int gid = tid + offset;
    printf("blockIdx: %d, threadIdx.x: %d, gid: %d, value: %d\n", 
        blockIdx, tid, gid, input[gid]);
}
int main()
{
    /* case 1 and 2:
    int h_data[] = { 23, 9, 4, 53, 65, 12, 1, 33 };*/
    int h_data[] = { 23, 9, 4, 53, 65, 12, 1, 33, 87, 45, 23, 12, 342, 56, 44, 99};
    int array_size = sizeof (h_data)/sizeof(int);
    printf("array_size: %d\n\n", array_size);
    int array_byte_size = sizeof(int) * array_size;
    for (int i = 0; i < array_size; i++) {
        printf("%d ", h_data[i]);
    }
    printf("\n\n");
    int * d_data;
    cudaMalloc((void **)&d_data, array_byte_size);
    cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);
    /*  case 1: one block in grid and 8 threads in each block
    dim3 block(8);
    dim3 grid(1);*/
    // case 2: two blocks in grid and 4 threds in each block
    /*dim3 block(4);
    dim3 grid(2);
    unique_idx_calc_threadIdx << < grid, block >> > (d_data);
    */
    // case 3: 4 block in grid and 4 thread in each block
    dim3 block(4);
    dim3 grid(4);
    unique_gid_calculation << < grid, block >> > (d_data);
    cudaDeviceSynchronize();
    int cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }
    return 0;
}
