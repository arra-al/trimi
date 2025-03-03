cmake_minimum_required(VERSION 3.20)
project(${PROJECT_NAME})

file(GLOB_RECURSE header_files ${INCLUDE_DIR}/*.hpp)
## list(APPEND header_files ${sources})
file(GLOB_RECURSE src_files ${SRC_DIR}/*.cpp)

add_library(game ${src_files} ${header_files})
