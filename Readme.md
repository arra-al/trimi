## Generate build files
cmake --preset windows-msvc-debug-developer-mode

## Build
cmake --build .\out\build\windows-msvc-debug-developer-mode\ --config {Debug, Release}
