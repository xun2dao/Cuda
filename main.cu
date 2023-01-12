#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#include<cstdio>
#include<cmath>
#include<vector>
#include<type_traits>
#include<cuda_runtime_api.h>
#include"cudaAllocator.h"
#include"Tick.h"
//#include<thrust/universal_vector.h>

__device__ __host__ void say_hello();

template<typename Func>
__global__ void kernel(int n, Func func){
  for(int i = blockIdx.x * blockDim.x + threadIdx.x;  i < n; i += blockDim.x*gridDim.x){
    func(i);
  }
}

__global__ void Iterate2D(float* devPtr, size_t pitch, int width, int height){
  printf("Pitch is %d\n", pitch);
  printf("width is %d\n", width);
  printf("height is %d\n", height);
  for(int i = 0; i < height; ++i){
    float* row = (float*)((char*)devPtr + i * pitch);
    for(int j = 0; j < width; ++j){
      float element = row[j];
    }
  }
}

__global__ void Iterate3D(cudaPitchedPtr ptr, int width, int height, int depth){
  char* devptr = (char*)ptr.ptr;
  size_t pitch = ptr.pitch;
  size_t slicePitch = pitch * height;
  printf("Pitch is %d\n", pitch);
  printf("slicePitch is %d\n", slicePitch);
  printf("width is %d\n", width);
  printf("heigth is %d\n", height);
  printf("depth is %d\n", depth);


  for(int i = 0; i < depth; ++i){
    char* slice =  devptr + i *slicePitch;
    for(int j = 0; j < height; ++j){
      float* row = (float*)(slice + j * pitch);
      for(int z = 0; z < width; ++z){
        float element = row[z];
      }
    }
  }
}

void device3DMemory(){
  int width = 64, height = 64, depth = 64;
  cudaExtent extent = make_cudaExtent(width, height, depth);
  cudaPitchedPtr pitchedPtr;
  cudaMalloc3D(&pitchedPtr,extent);
  Iterate3D<<<100, 100>>>(pitchedPtr, width, height, depth);
  cudaDeviceSynchronize();
  
}


 __device__ float* devsrc;
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
 // int n = 1 << 25;
 // int threads = 256;
 // int blocks = n / threads;
 // std::vector<float, cudaAllocator<float>> arr(n);
 // std::vector<float> cpu(n);
 // {
 //   Timer timer("GPU");
 //   kernel<<<20, 256>>>(n, [arr = arr.data()]__device__(int i){
 //     arr[i] = __sinf(i);
 //     });
 //   cudaDeviceSynchronize(); 
 //   cudaDeviceReset(); // 摧毁当前的CUDA上下文
 // }

 // {
 //   Timer timer("CPU");
 //   for(int i = 0; i < n; ++i) {
 //     cpu[i] = sinf(i);
 //   }
 // }
  /*
  int width = 64, height = 64;
  size_t pitch;
  float* devPtr;
  cudaMallocPitch(&devPtr, &pitch, width*sizeof(float), height);
  Iterate2D<<<100, 128>>>(devPtr, pitch, width, height);
  cudaDeviceSynchronize();
  cudaFree(devPtr);
  */
  
  //device3DMemory();
  
  float* src;
  cudaMalloc(&src, sizeof(float)*256);
  cudaMemcpyToSymbol(devsrc, &src, sizeof(src));  // 针对全局的device变量的数据
  return 0;
}
