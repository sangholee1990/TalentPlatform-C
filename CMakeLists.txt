cmake_minimum_required(VERSION 3.17)
project(CLion)

#set(CMAKE_CXX_STANDARD 14)
#set(CMAKE_C_COMPILER "C:/MinGW/bin/gcc.exe")
#set(CMAKE_CXX_COMPILER "C:/MinGW/bin/g++.exe")

add_executable(CLion
        .idea/CLion.iml
        .idea/modules.xml
        .idea/workspace.xml main.cpp)
