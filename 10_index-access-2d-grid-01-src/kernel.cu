// Case 2: 2D index
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

__global__ void unique_gid_calculation_2d(int* data)
{
    int tid = threadIdx.x;
    int block_offset = blockIdx.x * blockDim.x;
    int row_offset = blockDim.x * gridDim.x * blockIdx.y;
    int gid = row_offset + block_offset + tid;
    printf("Case 2: blockIdx.x: %d, blockIdx.y: %d, threadIdx.x: %d, gid: %d, value: %d\n",
        blockIdx.x, blockIdx.y, tid, gid, data[gid]);
}
int main()
{
    int h_data[] = { 23, 9, 4, 53, 65, 12, 1, 33, 22, 43, 56, 4, 76, 81, 94, 32};
    int array_size = sizeof(h_data) / sizeof(int);
    printf("case 2: array_size: %d\n\n", array_size);
    int array_byte_size = sizeof(int) * array_size;
    for (int i = 0; i < array_size; i++) {
        printf("%d ", h_data[i]);
    }
    printf("\n\n");
    int* d_data;
    cudaMalloc((void**)&d_data, array_byte_size);
    cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);
    // we have 4 threads in each block.
    // we have 2x2 blocks in grid.
    dim3 block(4);
    dim3 grid(2, 2);
    unique_gid_calculation_2d << < grid, block >> > (d_data);
    cudaDeviceSynchronize();
    int cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }
    return 0;
}


// case 1:
//#include "cuda_runtime.h"
//#include "device_launch_parameters.h"
//#include <stdio.h>
//
//__global__ void unique_gid_calculation_2d(int* data)
//{
//    int tid = threadIdx.x;
//    int offset = blockIdx.x * blockDim.x;
//    int gid = tid + offset;
//    printf("blockIdx.x: %d, blockIdx.y: %d, threadIdx.x: %d, gid: %d, value: %d\n",
//        blockIdx.x, blockIdx.y, tid, gid, data[gid]);
//}
//int main()
//{
//    int h_data[] = { 23, 9, 4, 53, 65, 12, 1, 33, 22, 43, 56, 4, 76, 81, 94, 32};
//    int array_size = sizeof(h_data) / sizeof(int);
//    printf("array_size: %d\n\n", array_size);
//    int array_byte_size = sizeof(int) * array_size;
//    for (int i = 0; i < array_size; i++) {
//        printf("%d ", h_data[i]);
//    }
//    printf("\n\n");
//    int* d_data;
//    cudaMalloc((void**)&d_data, array_byte_size);
//    cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);
//    // we have 4 threads in each block.
//    // we have 2x2 blocks in grid.
//    dim3 block(4);
//    dim3 grid(2, 2);
//    unique_gid_calculation_2d << < grid, block >> > (d_data);
//    cudaDeviceSynchronize();
//    int cudaStatus = cudaDeviceReset();
//    if (cudaStatus != cudaSuccess) {
//        fprintf(stderr, "cudaDeviceReset failed!");
//        return 1;
//    }
//    return 0;
//}
