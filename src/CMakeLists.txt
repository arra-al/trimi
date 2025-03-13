# cmake_minimum_required(VERSION 3.25)
project(${PROJECT_NAME})

file(GLOB_RECURSE header_files ./include/*.hpp)
## list(APPEND header_files ${sources})
file(GLOB_RECURSE src_files ./*.cpp)

# get raylib content props, and include it's headers files 
FetchContent_GetProperties(raylib)
message(STATUS "Raylib props " ${raylib_POPULATED} " " ${raylib_BINARY_DIR} " " ${raylib_SOURCE_DIR})

add_library(game)

# target_include_directories(game PRIVATE )

target_sources(game
	PUBLIC
		FILE_SET game_headers
		TYPE HEADERS
		BASE_DIRS ./include ${raylib_BINARY_DIR}/raylib/include
		FILES ${header_files}
	PRIVATE
		${src_files}
)

## install: library, and config files for use with find_package
include(GNUInstallDirs)

install(
	TARGETS game
	EXPORT game_exp
	FILE_SET game_headers DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

install(
	EXPORT game_exp
	NAMESPACE arra::
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/game"
)

install(
	FILES ./cmake/gameConfig.cmake
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/game"
)
