cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
project(cuquoi LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Adding subfolder property.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Sources.
add_subdirectory(src)
add_subdirectory(sample)
add_subdirectory(test)
