cmake_minimum_required(VERSION 3.12.1)
project(Cuda LANGUAGES CXX CUDA)

set(CMAKE_CUDA_ARCHITECTURES 75)
set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

aux_source_directory(./ SRCS)

add_executable(app ${SRCS})
target_include_directories(app PUBLIC ./)
target_compile_options(app PUBLIC $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)


