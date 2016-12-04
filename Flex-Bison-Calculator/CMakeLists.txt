cmake_minimum_required(VERSION 3.5)
project(Flex_Bison_Calculator)


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(SOURCE_FILES main.c calc.h calc.c errorManager.c errorManager.h)
add_executable(Flex_Bison_Calculator ${SOURCE_FILES})
target_link_libraries(Flex_Bison_Calculator m)