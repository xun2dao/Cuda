#include<cuda.h>
#include<cstdio>
__device__ __host__ void say_hello(){ // 通过__device__ 和__host__把say_hello同时定义在GPU和CPU上
#ifdef __CUDA_ARCH__   // 我们可以通过__CUDA_ARCH__这个宏区分一个被声明为__device__ __host__的函数此时究竟在哪里运行。
  printf("Say Hello GPU : %d\n", __CUDA_ARCH__);
#else
  printf("Say Hello CPU!\n");
#endif
}


