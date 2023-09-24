include(${CMAKE_SOURCE_DIR}/build-tools/cmake/Download.cmake)

#
download_and_extract_library(eigen-3.3.5 .zip https://gitlab.com/libeigen/eigen/-/archive/3.3.5/eigen-3.3.5.zip DIRECTORY)

#
set(flatbuffers_info
  "https://github.com/google/flatbuffers/releases/download/v2.0.0/Mac.flatc.binary.zip\;flatc\;flatc_mac"
  "https://github.com/google/flatbuffers/releases/download/v2.0.0/Linux.flatc.binary.clang++-9.zip\;flatc\;flatc_linux"
  "https://github.com/google/flatbuffers/releases/download/v2.0.0/Windows.flatc.binary.zip\;flatc.exe\;flatc_windows.exe"
  )

foreach(component ${flatbuffers_info})
  list(GET component 0 url)
  list(GET component 1 filename_old)
  list(GET component 2 filename_new)
  download_and_extract_library(${filename_new} .zip ${url} BINARY)
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E
    rename ${CMAKE_SOURCE_DIR}/third_party/${filename_old} ${CMAKE_SOURCE_DIR}/third_party/${filename_new})
endforeach()

if(BUILD_TEST)
  download_and_extract_library(googletest-release-1.10.0 .zip https://github.com/google/googletest/archive/release-1.10.0.zip DIRECTORY)
  add_subdirectory(googletest-release-1.10.0)
endif()

if(BUILD_CPP_UTILS)
  download_and_extract_library(cmdline-master .zip https://github.com/tanakh/cmdline/archive/master.zip DIRECTORY)
endif()
