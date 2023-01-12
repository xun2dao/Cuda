cmake_minimum_required(VERSION 3.12.1)
project(Cuda LANGUAGES CXX CUDA)

set(CMAKE_CUDA_ARCHITECTURES 75)
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON) # 启动cuda的定义和声明分离
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

aux_source_directory(./ SRCS)

add_executable(app ${SRCS})
target_include_directories(app PUBLIC ./)
# 下面的使用生成器表达式达到条件编译的结果。
set(is_cuda "$<COMPILE_LANGUAGE:CUDA>")
target_compile_options(app PUBLIC $<${is_cuda}:--extended-lambda>)
#target_compile_options(app PUBLIC $<${is_cuda}:--extended-const>)
target_compile_options(app PUBLIC $<${is_cuda}:-arch=sm_75>) # 指定生成的PTX code和binary code的版本

