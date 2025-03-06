include(cmake/SanitizeFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)

macro(trimi_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(trimi_setup_options)
  option(trimi_ENABLE_HARDENING "Enable hardening" ON)
  option(trimi_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    trimi_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    trimi_ENABLE_HARDENING
    OFF)

  trimi_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR trimi_PACKAGING_MAINTAINER_MODE)
    option(trimi_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(trimi_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(trimi_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(trimi_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(trimi_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(trimi_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(trimi_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(trimi_ENABLE_PCH "Enable precompiled headers" OFF)
    option(trimi_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(trimi_ENABLE_IPO "Enable IPO/LTO" ON)
    option(trimi_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(trimi_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(trimi_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(trimi_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(trimi_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(trimi_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(trimi_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(trimi_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(trimi_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(trimi_ENABLE_PCH "Enable precompiled headers" OFF)
    option(trimi_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      trimi_ENABLE_IPO
      trimi_WARNINGS_AS_ERRORS
      trimi_ENABLE_USER_LINKER
      trimi_ENABLE_SANITIZER_ADDRESS
      trimi_ENABLE_SANITIZER_LEAK
      trimi_ENABLE_SANITIZER_UNDEFINED
      trimi_ENABLE_SANITIZER_THREAD
      trimi_ENABLE_SANITIZER_MEMORY
      trimi_ENABLE_UNITY_BUILD
      trimi_ENABLE_CLANG_TIDY
      trimi_ENABLE_CPPCHECK
      trimi_ENABLE_COVERAGE
      trimi_ENABLE_PCH
      trimi_ENABLE_CACHE)
  endif()

  trimi_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (trimi_ENABLE_SANITIZER_ADDRESS OR trimi_ENABLE_SANITIZER_THREAD OR trimi_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(trimi_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(trimi_global_options)
  if(trimi_ENABLE_IPO)
    include(cmake/EnableIPO.cmake)
    trimi_enable_ipo()
  endif()

  trimi_supports_sanitizers()

  if(trimi_ENABLE_HARDENING AND trimi_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR trimi_ENABLE_SANITIZER_UNDEFINED
       OR trimi_ENABLE_SANITIZER_ADDRESS
       OR trimi_ENABLE_SANITIZER_THREAD
       OR trimi_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${trimi_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${trimi_ENABLE_SANITIZER_UNDEFINED}")
    trimi_enable_hardening(trimi_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()


macro(trimi_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(trimi_warnings INTERFACE)
  add_library(trimi_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  trimi_set_project_warnings(
    trimi_warnings
    ${trimi_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(trimi_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    trimi_configure_linker(trimi_options)
  endif()

  include(cmake/Sanitizers.cmake)
  trimi_enable_sanitizers(
    trimi_options
    ${trimi_ENABLE_SANITIZER_ADDRESS}
    ${trimi_ENABLE_SANITIZER_LEAK}
    ${trimi_ENABLE_SANITIZER_UNDEFINED}
    ${trimi_ENABLE_SANITIZER_THREAD}
    ${trimi_ENABLE_SANITIZER_MEMORY})

  set_target_properties(trimi_options PROPERTIES UNITY_BUILD ${trimi_ENABLE_UNITY_BUILD})

  if(trimi_ENABLE_PCH)
    target_precompile_headers(
      trimi_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(trimi_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    trimi_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(trimi_ENABLE_CLANG_TIDY)
    trimi_enable_clang_tidy(trimi_options ${trimi_WARNINGS_AS_ERRORS})
  endif()

  if(trimi_ENABLE_CPPCHECK)
    trimi_enable_cppcheck(${trimi_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(trimi_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    trimi_enable_coverage(trimi_options)
  endif()

  if(trimi_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(trimi_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(trimi_ENABLE_HARDENING AND NOT trimi_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR trimi_ENABLE_SANITIZER_UNDEFINED
       OR trimi_ENABLE_SANITIZER_ADDRESS
       OR trimi_ENABLE_SANITIZER_THREAD
       OR trimi_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    trimi_enable_hardening(trimi_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()