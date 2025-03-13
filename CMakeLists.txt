cmake_minimum_required(VERSION 3.25)

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

include(cmake/Dependencies.cmake)

add_subdirectory(src)
add_subdirectory(app)
## add_executable(main app/main.cpp)
#target_include_directories(main PUBLIC ${INCLUDE_DIR})
##target_link_libraries(main game raylib)
