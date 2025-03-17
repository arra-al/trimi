## cmake quick intro
- Set compilation flags for using #include: -I  target_include_directories
- Set linker flags: -L, -l  target_link_libraries
- Set flags to choose the c++ standard: -std=c++17  target_compile_features
- other compilation flags: -Wall, -Wextra  target_compile_options


## Generate build files
cmake --preset windows-msvc-debug-developer-mode

## Build
cmake --build .\out\build\windows-msvc-debug-developer-mode\ --config {Debug, Release}
