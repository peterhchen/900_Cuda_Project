
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void print_details ()
{
    printf("blockIdx.x: %d, blockIdx.y: %d, blockIdx: %d, \
        blockDim.x: %d, blockDim.y: %d, blockDim: %d, \
        gridDim.x: %d, gridDim.y: %d, girdDim: %d\n", \
        blockIdx.x, blockIdx.y, blockIdx.z, \
        blockDim.x, blockDim.y, blockDim.z, \
        gridDim.x, gridDim.y, gridDim.z);
}

int main()
{
    int nx = 16, ny = 16;
    dim3 block(8, 8);
    dim3 grid(nx / block.x, ny / block.y);
    print_details <<< grid, block >>> ();
    cudaDeviceSynchronize();
    int cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }
    cudaDeviceReset();
    return 0;
}
