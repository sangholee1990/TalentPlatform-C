
# 프로젝트 이름
project(CLion)

# 프로젝트 생성시 변수
#set(CMAKE_CXX_STANDARD 14)
#set(CMAKE_C_COMPILER "C:/MinGW/bin/gcc.exe")
#set(CMAKE_CXX_COMPILER "C:/MinGW/bin/g++.exe")

# 변수 ROOT 설정 = ..
set(ROOT ..)
# 변수 LIB_DIR 설정 = ../lib
set(LIB_DIR ../lib)
# 변수 MAIN_DIR 설정 = ../main
set(MAIN_DIR ../main)
# 변수 COMMON_DIR 설정 = ../common
set(COMMON_DIR ../common)


# 변수 LIB_LIST 설정 = ../libtest.cpp
set(LIB_LIST ${LIB_DIR}/libtest.cpp)

# 변수 LIB_NAME 설정 = libtest
set(LIB_NAME libtest)

# 변수 SOURCE 설정 = ../main/main.cpp ../main/function.cpp
set(SOURCE ${MAIN_DIR}/main.cpp ${MAIN_DIR}/function.cpp)

# 변수 OUTPUT 설정 = ../program.out
set(OUTPUT ${ROOT}/program.out)

# 변수 EXE_FILE 설정 = program
set(EXE_FILE program)

# 최소 cmake 요구 버젼
cmake_minimum_required(VERSION 3.17)

# 메시지 설정
message(${CMAKE_PROJECT_NAME})

# 컴파일 옵션 = g++ -W -Wall -o -c source
add_compile_options(-W -Wall)

# 공통 해더 파일 설정
include_directories(${COMMON_DIR})

# 빌드 설정
add_executable(${OUTPUT} ${SOURCE})

# 라이브러리 설정, 라이브러리 이름 = libtest.so
add_library(${LIB_NAME} SHARED ${LIB_LIST})

# 빌드시에 참조 라이브러리
target_link_libraries(${OUTPUT} PUBLIC ${LIB_NAME})

# make install 설정, TARGETS 1, 2 ,3 = RUNTIME DESTINATION, LIBRARY DESTINATION, ARCHIVE DESTINATION
install(TARGETS ${OUTPUT} ${LIB_NAME}
        RUNTIME DESTINATION /home/bin
        LIBRARY DESTINATION /home/lib)

#find_package(Boost REQUIRED COMPONENTS iostreams system filesystem)
#target_include_directories(yourTarget PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${Boost_INCLUDE_DIRS})
#target_link_libraries(yourTarget PUBLIC ${Boost_LIBRARIES})

# 실행 파라메타
#add_executable(CLion ../main/main.cpp ../main/function.cpp ../main/function.h ../lib/libtest.cpp ../common/libtest.h)
#add_executable(CLion
#        .idea/CLion.iml
#        .idea/modules.xml
#        .idea/workspace.xml main.cpp)
