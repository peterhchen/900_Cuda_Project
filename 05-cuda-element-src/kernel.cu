
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

__global__ void hello_cuda()
{
    printf("Hello Cuda world\n");
}

int main()
{
    // case 1:
    /*hello_cuda << < 1,1 > >> ();*/
    /*hello_cuda << < 1,2 > >> ();*/
    // case 2:
    // 3 x 2
    //dim3 block(2, 1, 1);
    //dim3 grid(3, 1, 1);
    
    //case 3:
    // 2x2, 8x2
    // dim3 block(8, 2, 1);
    // dim3 grid(2, 2, 1);

    int nx = 16, ny = 4;
    dim3 block(8, 2, 1);
    dim3 grid(nx / block.x, ny / block.y);
    hello_cuda <<< grid, block >>> ();
    cudaDeviceSynchronize();
    cudaDeviceReset();
    return 0;
}