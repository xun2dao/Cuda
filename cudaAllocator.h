#pragma once
#include<iostream>
template<typename T>
class cudaAllocator{
  public:
  using value_type = T;
  T* allocate(size_t n) {
    T* retAddr;
    cudaMallocManaged(&retAddr, n);
    return retAddr;
  }

  void deallocate(T* addr, size_t n = 0){
    cudaFree(addr);
  }

  template<class ...Args>
  void construct(T* p, Args&& ...args){
    if constexpr (!(sizeof...(Args) == 0 && std::is_pod<T>::value))
      ::new((void*)p) T(std::forward<Args>(args)...);
  }
};
