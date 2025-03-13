#cmake_minimum_required(VERSION 3.25)

set(TRIMI_TARGET_NAME ${PROJECT_NAME})

project(${TRIMI_TARGET_NAME})

add_executable(${TRIMI_TARGET_NAME} main.cpp)

# Set the asset path macro in release mode to a relative path that assumes the assets folder is in the same directory as the game executable
target_compile_definitions(${PROJECT_NAME} PUBLIC ASSETS_PATH="./assets/")

target_sources(${TRIMI_TARGET_NAME}
    PRIVATE
        main.cpp
)

target_link_libraries(${TRIMI_TARGET_NAME} PRIVATE game raylib)
