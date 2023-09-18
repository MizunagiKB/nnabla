#
download_and_extract_library(zlib-1.3 .zip https://github.com/madler/zlib/archive/refs/tags/v1.3.zip DIRECTORY)
download_and_extract_library(zstd-1.5.5 .zip https://github.com/facebook/zstd/archive/refs/tags/v1.5.5.zip DIRECTORY)
file(MAKE_DIRECTORY ${NBLA_ROOT_CMAKE_DIR}/third_party/zstd-1.5.5/build.cmake)
if(NBLA_BUILD_SHARED_LIBS)
  set(ZSTD_BUILD_SHARED "ON")
  set(ZSTD_BUILD_STATIC "OFF")
else()
  set(ZSTD_BUILD_SHARED "OFF")
  set(ZSTD_BUILD_STATIC "ON")
endif()
execute_process(
  COMMAND
  cmake "../build/cmake"
    "-DZSTD_PROGRAMS_LINK_SHARED=${NBLA_BUILD_SHARED_LIBS}"
    "-DZSTD_BUILD_SHARED=${ZSTD_BUILD_SHARED}"
    "-DZSTD_BUILD_STATIC=${ZSTD_BUILD_STATIC}"
  WORKING_DIRECTORY
    ${NBLA_ROOT_CMAKE_DIR}/third_party/zstd-1.5.5/build.cmake
)
execute_process(
  COMMAND
  make
  WORKING_DIRECTORY
  ${NBLA_ROOT_CMAKE_DIR}/third_party/zstd-1.5.5/build.cmake
)

#
download_and_extract_library(libarchive-3.7.2 .zip https://github.com/libarchive/libarchive/archive/refs/tags/v3.7.2.zip DIRECTORY)
file(MAKE_DIRECTORY ${NBLA_ROOT_CMAKE_DIR}/third_party/libarchive-3.7.2/build.cmake)
execute_process(
  COMMAND
  cmake ".."
    "-DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}"
    "-DENABLE_NETTLE=OFF"
    "-DENABLE_OPENSSL=OFF"
    "-DENABLE_LZO=OFF"
    "-DENABLE_LZMA=OFF"
    "-DENABLE_BZip2=OFF"
    "-DENABLE_LIBXML2=OFF"
    "-DENABLE_EXPAT=OFF"
    "-DENABLE_PCREPOSIX=OFF"
    "-DENABLE_LibGCC=OFF"
    "-DENABLE_CNG=OFF"
    "-DENABLE_TAR=OFF"
    "-DENABLE_TAR_SHARED=OFF"
    "-DENABLE_CPIO=OFF"
    "-DENABLE_CPIO_SHARED=OFF"
    "-DENABLE_CAT=OFF"
    "-DENABLE_CAT_SHARED=OFF"
    "-DENABLE_XATTR=OFF"
    "-DENABLE_ACL=OFF"
    "-DENABLE_ICONV=OFF"
    "-DENABLE_TEST=OFF"
    "-DZLIB_INCLUDE_DIR=${NBLA_ROOT_CMAKE_DIR}/third_party/zlib-1.3"
    "-DZLIB_LIBRARY_RELEASE=ON"
  WORKING_DIRECTORY
    ${NBLA_ROOT_CMAKE_DIR}/third_party/libarchive-3.7.2/build.cmake
)
execute_process(
  COMMAND
  make
  WORKING_DIRECTORY
  ${NBLA_ROOT_CMAKE_DIR}/third_party/libarchive-3.7.2/build.cmake
)


if(NNABLA_UTILS_WITH_HDF5)
  set(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT OFF)
  download_and_extract_library(hdf5-hdf5-1_12_2 .zip https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_12_2.zip DIRECTORY)
  set(HDF5_EXTERNALLY_CONFIGURED, 1)
  set(HDF5_EXPORTED_TARGETS "nbla_utils-hdf5-targets")
  file(MAKE_DIRECTORY ${NBLA_ROOT_CMAKE_DIR}/third_party/hdf5-hdf5-1_12_2/build.cmake)
  if(NBLA_BUILD_SHARED_LIBS)
    execute_process(
      COMMAND
      cmake "-DBUILD_SHARED_LIBS=ON" "HDF5_BUILD_HL_LIB=ON" ".."
      WORKING_DIRECTORY
      "${NBLA_ROOT_CMAKE_DIR}/third_party/hdf5-hdf5-1_12_2/build.cmake"
    )
  else()
    execute_process(
      COMMAND
      cmake "-DBUILD_SHARED_LIBS=OFF" "HDF5_BUILD_HL_LIB=ON" ".."
      WORKING_DIRECTORY
      "${NBLA_ROOT_CMAKE_DIR}/third_party/hdf5-hdf5-1_12_2/build.cmake"
    )
  endif()
  execute_process(
    COMMAND
    make
    WORKING_DIRECTORY
    "${NBLA_ROOT_CMAKE_DIR}/third_party/hdf5-hdf5-1_12_2/build.cmake"
  )
endif()


download_and_extract_library(eigen-3.3.5 .zip https://gitlab.com/libeigen/eigen/-/archive/3.3.5/eigen-3.3.5.zip DIRECTORY)


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
