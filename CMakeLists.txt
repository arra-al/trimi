cmake_minimum_required(VERSION 3.21)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Only set the cxx_standard if it is not set by someone else
if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED On)
endif()

project(
    trimi
    VERSION 0.0.1
    DESCRIPTION "Simple 2D game using raylib"
    LANGUAGES CXX C)


include(cmake/InSourceBuilds.cmake)
include(cmake/ProjectOptions.cmake)

trimi_setup_options()
trimi_global_options()

set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

#file(GLOB_RECURSE header_files ${INCLUDE_DIR}/*.hpp)
## list(APPEND header_files ${sources})
#file(GLOB_RECURSE src_files ${SRC_DIR}/*.cpp)

include_directories(${INCLUDE_DIR})

# message(STATUS "current src dir" ${CMAKE_CURRENT_SOURCE_DIR})
# message(STATUS "src dir" ${CMAKE_SOURCE_DIR})

# message(STATUS "header files: " ${header_files})
# message(STATUS "src files: " ${src_files})


#add_library(game ${src_files} ${header_files})

add_subdirectory(${SRC_DIR})
add_subdirectory(app)
## add_executable(main app/main.cpp)
#target_include_directories(main PUBLIC ${INCLUDE_DIR})
##target_link_libraries(main game raylib)
