#cmake_minimum_required(VERSION 3.25)

set(TRIMI_TARGET_NAME ${PROJECT_NAME})

project(${TRIMI_TARGET_NAME})



add_executable(${TRIMI_TARGET_NAME} main.cpp)

target_sources(${TRIMI_TARGET_NAME}
    PRIVATE
        main.cpp
)

target_link_libraries(${TRIMI_TARGET_NAME} PRIVATE game raylib)
