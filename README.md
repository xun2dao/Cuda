# Cuda Programming

## 1. Cuda对C++的语法兼容
+ `__global__` : 申明核函数， 相当于GPU运行的入口地址
+ `__device__` : 申明GPU函数， 只能在GPU上运行
+ `__host__`
+ constexpr


对于一个同时被`__device__` 和`__host__` 修饰的函数f而言，f可以在CPU上运行，也可以在
GPU上运行，如果我们想根据当前的设备选择不同的运行逻辑，可以通过一个宏`__CUDA_ARCH__`
判断当前函数是否运行在GPU上。
之所以f可以同时在GPU和CPU上运行，是因为cuda的代码实际上要经过两次编译，第一次为CPU
编译，预处理的时候，会将host的代码取出来，第二次为GPU编译，预处理的时候将device的代码
取出来。

**Cuda默认不支持将函数的声明和实现分离的，但是我们可以在cmake中设置 
`CMAKE_CUDA_SEPARABLE_COMPILATION`实现分离。**


## 2. Thread, Block, Grid 的概念
+ Thread:
+ Block:
+ Grid:


## 3. Cuda的内存分配
Device的内存分配和Host的内存分配不在一个寻址系统中，所以我们在进行内存分配的时候
需要注意，如果想在GPU的显存上分配空间，可以直接调用cudaMalloc函数，如果想把显存上
的数据传输到Host上面，我们还需要调用cudaMemcpy函数。

cudaMemcpy是一个隐含了同步的函数，方便我们编写代码。

在现在的GPU上，已经出现了统一内存分配，我们可以通过cudaMallocManaged分配统一的内存地址。

cuda的内存分配函数有多个:

+ cudaMalloc      ： 一维线性分配
+ cudaMallocPitch ： 二维padded分配
+ cudaMalloc3D    ： 三维分配


cuda 中还有device全局变量，我们可以通过下面函数在全局变量和普通变量之间传递函数。
全局变量的修饰符有 `__device__`， `__constant__`, `__managed`

cudaMemcpyToSymbol(gvar, nvar, size);

## 4. 数组的遍历

+ 一个线程遍历整个数组
+ 每个线程负责一个数组元素
+ 跨步循环

使用grid网格以及边角料问题 ：

+ 向上取整 + 判断
+ 网格版本的跨步循环(跨步循环的本质是扁平化)

跨步循环的好处就是可以完全不用考虑线程的数量，数据会自动分配到每个线程上。

### 4.1 对c++的vector进行封装

创建一个cudaAllocator，用来在主存和显存上分配空间。
```c++
template<typename T>
class cudaAllocator{
  public:
  using value_type = T;
  T* allocate(size_t n) {
    std::cout<<"allocate memory"<<std::endl;
    T* retAddr;
    cudaMallocManaged(&retAddr, n);
    return retAddr;
  }

  void deallocate(T* addr, size_t n = 0){
    cudaFree(addr);
  }

  template<class ...Args>
  void construct(T* p, Args&&...args){
    if constexpr (!(sizeof...(Args)==0 && std::is_pod<T>::value)){
      ::new((void*)p) T(std::forward<Args>(args)...);
    }
  }
};
```
### 4.2 nvcc 支持lambda和仿函数和模板
如果需要nvcc支持lambda表达式，必须设置编译的选项`--extended-lambda`.
nvcc 编译cuda代码的形式有三种:

1. 离线编译 : nvcc现将device 代码转换为 PTX code 或者 binary code.然后将其插入host代码中，调用其他的编译器编译host代码。
2. 即时编译(just-in-time), nvcc将device代码编程PTX code，在运行时，由驱动即时将PTX code转换为binary code。
3. 运行时编译NVRTC? : 这种方式有点像解释器。


## 5. cuda数学函数


## 6. thrust库, 模拟c++ STL


## 7. 原子操作

## 8. cuda 运行时库
cuda 运行时库会在第一个运行时库的非错误检查的函数被调用时初始化。由于cuda的函数需要
cuda上下文(context),所以第一次调用的时候，就会创建一个cuda context，我们可以通过函数
`cudaDeviceReset()`销毁当前正在使用的cuda context，之后的cuda库函数仍然会重新创建一个
cuda上下文。

