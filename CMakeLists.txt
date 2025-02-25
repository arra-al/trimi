cmake_minimum_required(VERSION 3.20)
project(trimi)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

set(header_files)
file(GLOB_RECURSE header_files ${INCLUDE_DIR}/*.hpp)
## list(APPEND header_files ${sources})
file(GLOB_RECURSE src_files ${SRC_DIR}/*.cpp)

include_directories(${INCLUDE_DIR})

# message(STATUS "current src dir" ${CMAKE_CURRENT_SOURCE_DIR})
# message(STATUS "src dir" ${CMAKE_SOURCE_DIR})

# message(STATUS "header files: " ${header_files})
# message(STATUS "src files: " ${src_files})


add_library(game ${src_files} ${header_files})
add_executable(main app/main.cpp)
#target_include_directories(main PUBLIC ${INCLUDE_DIR})
target_link_libraries(main game raylib)
