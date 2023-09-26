# 
include(${CMAKE_SOURCE_DIR}/build-tools/cmake/Download.cmake)


# =============================================================================
# libarchive
function(build_libarchive NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_LIBARCHIVE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -DZLIB_ROOT=${ZLIB_ROOT}
            # -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
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
    WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build .
      WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)

    set(TMP_INC_DIR ${NBLA_LIBARCHIVE_DIR}/libarchive)
    set(TMP_LIB ${NBLA_LIBARCHIVE_DIR}/build.cmake/libarchive/${CMAKE_BUILD_TYPE}/archive.lib)

    set(LibArchive_INCLUDE_DIR ${TMP_INC_DIR} PARENT_SCOPE)
    set(LibArchive_LIBRARIES ${TMP_LIB} PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_LIBARCHIVE_DIR}/build.cmake)
  endif()

  message("  <<build_libarchive>>")
  message("  - LibArchive_INCLUDE_DIR = " ${TMP_INC_DIR})
  message("  - LibArchive_LIBRARIES = " ${TMP_LIB})

endfunction()


# =============================================================================
# hdf5
function(build_hdf5 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_HDF5_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)

  if(RUN_CMAKE)
  execute_process(
    COMMAND cmake ..
            # -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
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

    set(TMP_INC_DIR ${NBLA_HDF5_DIR}/include)
    set(TMP_LIB_1 ${NBLA_HDF5_DIR}/lib/hdf5.lib)
    set(TMP_LIB_2 ${NBLA_HDF5_DIR}/lib/hdf5_hl.lib)
    set(TMP_LIB_3 "")

    set(HDF5_INCLUDE_DIRS ${TMP_INC_DIR} PARENT_SCOPE)
    set(HDF5_LIBRARIES ${TMP_LIB_1} ${TMP_LIB_2} PARENT_SCOPE)
    set(HDF5_HL_LIBRARIES ${TMP_LIB_3} PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)
  endif()

  message("  <<build_hdf5>>")
  message("  - HDF5_INCLUDE_DIRS = " ${TMP_INC_DIR})
  message("  - HDF5_LIBRARIES = " ${TMP_LIB_1})
  message("  - HDF5_LIBRARIES = " ${TMP_LIB_2})
  message("  - HDF5_HL_LIBRARIES = " ${TMP_LIB_3})

endfunction()


# =============================================================================
# protobuf
function(build_protobuf NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(NBLA_PROTOBUF_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  file(MAKE_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            # -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
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

    find_program(SET_COMMAND protoc ${NBLA_PROTOBUF_DIR}/build.cmake/${CMAKE_BUILD_TYPE})
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
  message("  - PROTOC_COMMAND = " ${SET_COMMAND})

endfunction()


# =============================================================================
# zlib
function(build_zlib NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${NBLA_ZLIB_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

    set(TMP_INC_DIR ${TMP_BASE_DIR})
    set(TMP_LIB_1 ${TMP_BASE_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlib${DEBUG_SUFFIX}.lib)
    set(TMP_LIB_STATIC_1 ${TMP_BASE_DIR}/build.cmake/${CMAKE_BUILD_TYPE}/zlibstatic${DEBUG_SUFFIX}.lib)

    set(ZLIB_ROOT ${TMP_INST_DIR} PARENT_SCOPE)
    #set(ZLIB_INCLUDE_DIRS ${TMP_INC_DIR} PARENT_SCOPE)
    #if(${NBLA_BUILD_SHARED_LIBS} STREQUAL ON)
    #  set(ZLIB_LIBRARIES ${TMP_LIB_1} PARENT_SCOPE)
    #else()
    #  set(ZLIB_LIBRARIES ${TMP_LIB_STATIC_1} PARENT_SCOPE)
    #endif()

  else()
  endif()

  message("  <<build_zlib>>")
  message("  - ZLIB_INCLUDE_DIRS = " ${TMP_INC_DIR})
  if(${NBLA_BUILD_SHARED_LIBS} STREQUAL ON)
    message("  - ZLIB_LIBRARIES = " ${TMP_LIB_1})
  else()
    message("  - ZLIB_LIBRARIES = " ${TMP_LIB_STATIC_1})
  endif()

endfunction()


# =============================================================================
# zstd
function(build_zstd NAME EXT URL)
  download_and_extract_library(zstd-1.5.5 .zip https://github.com/facebook/zstd/archive/refs/tags/v1.5.5.zip DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ../build/cmake
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            # -DBUILD_SHARED_LIBS=${NBLA_BUILD_SHARED_LIBS}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
      set(DEBUG_SUFFIX "d")
    else()
      set(DEBUG_SUFFIX "")
    endif()

    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

    set(TMP_INC_DIR ${TMP_BASE_DIR}/lib)
    set(TMP_LIB_1 ${TMP_BASE_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd.lib)
    set(TMP_LIB_STATIC_1 ${TMP_BASE_DIR}/build.cmake/lib/${CMAKE_BUILD_TYPE}/zstd_static.lib)
    
    set(ZSTD_INCLUDE_DIR ${TMP_INC_DIR} PARENT_SCOPE)

    if(${NBLA_BUILD_SHARED_LIBS} STREQUAL ON)
      set(ZSTD_LIBRARY ${TMP_LIB_1} PARENT_SCOPE)
    else()
      set(ZSTD_LIBRARY ${TMP_LIB_STATIC_1} PARENT_SCOPE)
    endif()

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  endif()

  message("  <<build_zstd>>")
  message("  - ZSTD_INCLUDE_DIR = " ${TMP_INC_DIR})
  if(${NBLA_BUILD_SHARED_LIBS} STREQUAL ON)
    message("  - ZSTD_LIBRARY = " ${TMP_LIB_1})
  else()
    message("  - ZSTD_LIBRARY = " ${TMP_LIB_STATIC_1})
  endif()

endfunction()
