#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<cstdio>
#include<cmath>
#include<vector>
#include<type_traits>
#include"cudaAllocator.h"


__device__ __host__ void say_hello();

template<typename Func>
__global__ void kernel(int n, Func func){
  for(int i = blockIdx.x * blockDim.x + threadIdx.x;  i < n; i += blockDim.x*gridDim.x){
    func(i);
  }
}


int main(){
  //int *pret;
  // 在显存上分配数据
  /*
  cudaError_t merr = cudaMalloc(&pret, sizeof(int));
  kernel<<<1, 5>>>(pret);
  cudaError_t err = cudaDeviceSynchronize();
  int ret;
  // 从显存拷贝的内存
  cudaMemcpy(&ret, pret, sizeof(int), cudaMemcpyDeviceToHost);

  cudaFree(pret);
  
  printf("Cuda Get Error: %d\n", err);
  printf("Cuda Error is %s\n", cudaGetErrorName(err));
  printf("ret's value is %d\n",ret);
  */
  /*
  cudaMallocManaged(&pret, sizeof(int)); // 统一内存地址分配
  kernel<<<1,1>>>(pret);
  cudaDeviceSynchronize(); // 使用统一地址分配，不要忘记同步。
  printf("Ret value is %d\n", *pret);
  cudaFree(pret);
  */


  // 对数组进行赋值
  int n = 100;
  int threads = 256;
  int blocks = n / threads;
  std::vector<int, cudaAllocator<int>> arr(n);
  kernel<<<1, 10>>>(n, [arr = arr.data()]__device__(int i){
    arr[i] = i;
    printf("arr[%d] = %d\n", i, arr[i]);
    });
  cudaDeviceSynchronize(); 
  return 0;
}
