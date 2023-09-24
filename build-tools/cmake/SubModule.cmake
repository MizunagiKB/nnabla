# 
include(${CMAKE_SOURCE_DIR}/build-tools/cmake/Download.cmake)


# libarchive
function(build_libarchive NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_LIBARCHIVE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
  if(RUN_CMAKE)
    execute_process(
      COMMAND cmake ..
              -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
              -DENABLE_MBEDTLS=OFF
              -DENABLE_NETTLE=OFF
              -DENABLE_OPENSSL=OFF
              -DENABLE_LIBB2=ON
              -DENABLE_LZ4=ON
              -DENABLE_LZO=OFF
              -DENABLE_LZMA=OFF
              -DENABLE_ZSTD=ON
              -DENABLE_ZLIB=ON
              -DENABLE_BZip2=OFF
              -DENABLE_LIBXML2=OFF
              -DENABLE_EXPAT=OFF
              -DENABLE_PCREPOSIX=OFF
              -DENABLE_LIBGCC=OFF
              -DENABLE_CNG=OFF
              -DENABLE_TAR=OFF
              -DENABLE_TAR_SHARED=OFF
              -DENABLE_CPIO=OFF
              -DENABLE_CPIO_SHARED=OFF
              -DENABLE_CAT=OFF
              -DENABLE_CAT_SHARED=OFF
              -DENABLE_UNZIP=OFF
              -DENABLE_UNZIP_SHARED=OFF
              -DENABLE_XATTR=OFF
              -DENABLE_ACL=OFF
              -DENABLE_ICONV=OFF
              -DENABLE_TEST=OFF
              -DENABLE_COVERAGE=OFF
              -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
              -DZSTD_INCLUDE_DIR=${ZSTD_INCLUDE_DIR}
      WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
  endif() # RUN_CMAKE

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    #execute_process(
    #  COMMAND cmake --build .
    #  WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
    set(NBLA_LIBARCHIVE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/libarchive)

    # set(LibArchive_INCLUDE_DIR ${NBLA_LIBARCHIVE_DIR}/libarchive PARENT_SCOPE)
    # set(LibArchive_LIBRARIES ${NBLA_LIBARCHIVE_DIR}/build.cmake/libarchive/${CMAKE_BUILD_TYPE}/archive.lib PARENT_SCOPE)

    set(LibArchive_INCLUDE_DIR ${NBLA_LIBARCHIVE_DIR}/include PARENT_SCOPE)
    set(LibArchive_LIBRARIES ${NBLA_LIBARCHIVE_DIR}/lib/archive.lib PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
  endif()

  message("  <<build_libarchive>>")
  message("  - LibArchive_INCLUDE_DIR = " ${NBLA_LIBARCHIVE_DIR}/libarchive)
  message("  - LibArchive_LIBRARIES = " ${NBLA_LIBARCHIVE_DIR}/build.cmake/libarchive/${CMAKE_BUILD_TYPE}/archive.lib)

endfunction()


# hdf5
function(build_hdf5 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_HDF5_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)

  if(RUN_CMAKE)
  execute_process(
    COMMAND cmake ..
            -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
            -DHDF5_BUILD_HL_LIB=ON
            -DHDF5_EXPORTED_TARGETS=nbla_utils-hdf5-targets
            -DHDF5_EXTERNALLY_CONFIGURED=1
            -DHDF5_USE_STATIC_LIBRARIES=1
            -DHDF5_BUILD_EXAMPLES=OFF
            -DBUILD_TESTING=OFF
    WORKING_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)
  endif() # RUN_CMAKE

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "_D")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    #execute_process(
    #  COMMAND cmake --build .
    #  WORKING_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)

    set(NBLA_HDF5_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/HDF5-1.14.3.3b5b26b-win64)

    set(HDF5_INCLUDE_DIRS ${NBLA_HDF5_DIR}/include PARENT_SCOPE)
    set(
        HDF5_LIBRARIES ${NBLA_HDF5_DIR}/lib/hdf5.lib
                       ${NBLA_HDF5_DIR}/lib/hdf5_hl.lib
                       ${NBLA_HDF5_DIR}/lib/hdf5_tools.lib
        PARENT_SCOPE)
    set(HDF5_HL_LIBRARIES PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)
  endif()

  message("  <<build_hdf5>>")
  message("  - HDF5_INCLUDE_DIRS = " ${NBLA_HDF5_DIR}/build.cmake/src)
  message("  - HDF5_INCLUDE_DIRS = " ${NBLA_HDF5_DIR}/hl/src)
  message("  - HDF5_INCLUDE_DIRS = " ${NBLA_HDF5_DIR}/src)
  message("  - HDF5_LIBRARIES = " ${NBLA_HDF5_DIR}/build.cmake/bin/${CMAKE_BUILD_TYPE}/libhdf5${DEBUG_SUFFIX}.lib)
  message("  - HDF5_LIBRARIES = " ${NBLA_HDF5_DIR}/build.cmake/bin/${CMAKE_BUILD_TYPE}/libhdf5_tools${DEBUG_SUFFIX}.lib)
  message("  - HDF5_HL_LIBRARIES = " ${NBLA_HDF5_DIR}/build.cmake/bin/${CMAKE_BUILD_TYPE}/libhdf5_hl${DEBUG_SUFFIX}.lib)

endfunction()


# protobuf
function(build_protobuf NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_PROTOBUF_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ../cmake
            -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
            -DCMAKE_POSITION_INDEPENDENT_CODE=ON
            -Dprotobuf_BUILD_TESTS=OFF
    WORKING_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build .
      WORKING_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)

    find_program(PROTOC_COMMAND protoc ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE} PARENT_SCOPE)

    set(PROTOBUF_INCLUDE_DIR ${NBLA_PROTOBUF_DIR}/src PARENT_SCOPE)
    set(
      PROTOBUF_LIBRARY ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/libprotobuf${DEBUG_SUFFIX}.lib
                       ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/libprotoc${DEBUG_SUFFIX}.lib
      PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)
    find_program(PROTOC_COMMAND protoc ${NBLA_PROTOBUF_DIR}/build.cmake PARENT_SCOPE)
  endif()

  message("  <<build_protobuf>>")
  message("  - PROTOBUF_INCLUDE_DIR = " ${NBLA_PROTOBUF_DIR}/src)
  message("  - PROTOBUF_LIBRARY = " ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/libprotobuf${DEBUG_SUFFIX}.lib)
  message("  - PROTOBUF_LIBRARY = " ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/libprotoc${DEBUG_SUFFIX}.lib)
  message("  - PROTOC_COMMAND = " ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE})

endfunction()


# zlib
function(build_zlib NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_ZLIB_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_ZLIB_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
    WORKING_DIRECTORY ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build .
      WORKING_DIRECTORY ${NBLA_ZLIB_DIR}/build.cmake)

    set(ZLIB_INCLUDE_DIR ${NBLA_ZLIB_DIR} PARENT_SCOPE)
    if(NBLA_BUILD_SHARED_LIBS)
      set(ZLIB_LIBRARIES ${NBLA_ZLIB_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlib${DEBUG_SUFFIX}.lib PARENT_SCOPE)
    else()
      set(ZLIB_LIBRARIES ${NBLA_ZLIB_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlibstatic${DEBUG_SUFFIX}.lib PARENT_SCOPE)
    endif()
  else()
  endif()

  message("  <<build_zlib>>")
  message("  - ZLIB_INCLUDE_DIR = " ${NBLA_ZLIB_DIR})
  if(NBLA_BUILD_SHARED_LIBS)
      message("  - ZLIB_LIBRARIES = " ${NBLA_ZLIB_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlib${DEBUG_SUFFIX}.lib)
  else()
      message("  - ZLIB_LIBRARIES = " ${NBLA_ZLIB_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlibstatic${DEBUG_SUFFIX}.lib)
  endif()

endfunction()


function(build_zstd NAME EXT URL)
  download_and_extract_library(zstd-1.5.5 .zip https://github.com/facebook/zstd/archive/refs/tags/v1.5.5.zip DIRECTORY)
  set(NBLA_ZSTD_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_ZSTD_DIR}/build.cmake)
  if(NBLA_BUILD_SHARED_LIBS)
    set(ZSTD_BUILD_SHARED "ON")
    set(ZSTD_BUILD_STATIC "OFF")
  else()
    set(ZSTD_BUILD_SHARED "OFF")
    set(ZSTD_BUILD_STATIC "ON")
  endif()
  execute_process(
    COMMAND cmake ../build/cmake
            -DZSTD_PROGRAMS_LINK_SHARED=${NBLA_BUILD_SHARED_LIBS}
            -DZSTD_BUILD_SHARED=${ZSTD_BUILD_SHARED}
            -DZSTD_BUILD_STATIC=${ZSTD_BUILD_STATIC}
    WORKING_DIRECTORY ${NBLA_ZSTD_DIR}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build .
      WORKING_DIRECTORY ${NBLA_ZSTD_DIR}/build.cmake)

    set(ZSTD_INCLUDE_DIR ${NBLA_ZSTD_DIR}/lib PARENT_SCOPE)

    if(NBLA_BUILD_SHARED_LIBS)
      set(ZSTD_LIBRARY ${NBLA_ZSTD_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd.lib PARENT_SCOPE)
    else()
      set(ZSTD_LIBRARY ${NBLA_ZSTD_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd_static.lib PARENT_SCOPE)
    endif()

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_ZSTD_DIR}/build.cmake)
  endif()

  message("  <<build_zstd>>")
  if(NBLA_BUILD_SHARED_LIBS)
    message("  - ZSTD_LIBRARY = " ${NBLA_ZSTD_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd.lib)
  else()
    message("  - ZSTD_LIBRARY = " ${NBLA_ZSTD_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd_static.lib)
  endif()

endfunction()
