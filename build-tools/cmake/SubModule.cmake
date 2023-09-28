# 
include(${CMAKE_SOURCE_DIR}/build-tools/cmake/Download.cmake)


# =============================================================================
# libarchive
function(build_libarchive NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -DBUILD_SHARED_LIBS=ON
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DZLIB_ROOT=${ZLIB_ROOT}
            -DPC_ZSTD_INCLUDEDIR=${PC_ZSTD_INCLUDEDIR}
            -DPC_ZSTD_LIBDIR=${PC_ZSTD_LIBDIR}
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
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  
  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  endif()

  Find_Package(LibArchive)

  if(NOT LibArchive_FOUND)
    error_abort()
  else()
    message("  <<build_libarchive>>")
    message("  LibArchive_INCLUDE_DIR = " ${LibArchive_INCLUDE_DIR})
    message("    LibArchive_LIBRARIES = " ${LibArchive_LIBRARIES})
  endif()

endfunction()


# =============================================================================
# hdf5
function(build_hdf5 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake ..
            -DBUILD_SHARED_LIBS=ON
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DHDF5_BUILD_HL_LIB=ON
            -DHDF5_EXPORTED_TARGETS=nbla_utils-hdf5-targets
            -DHDF5_EXTERNALLY_CONFIGURED=1
            -DHDF5_BUILD_EXAMPLES=OFF
            -DBUILD_TESTING=OFF
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config=Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  
    # set(HDF5_ROOT ${TMP_INST_DIR} PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_HDF5_DIR}/build.cmake)
  endif()

  Find_Package(HDF5 COMPONENTS C HL REQUIRED)

  if(NOT HDF5_FOUND)
    error_abort()
  else()
    message("  <<build_hdf5>>")
    message("  HDF5_INCLUDE_DIR = " ${HDF5_INCLUDE_DIR})
    message("    HDF5_LIBRARIES = " ${HDF5_LIBRARIES})
    message(" HDF5_HL_LIBRARIES = " ${HDF5_HL_LIBRARIES})
  endif()

endfunction()


# =============================================================================
# protobuf
function(build_protobuf NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -Dprotobuf_BUILD_SHARED_LIBS=ON
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -Dprotobuf_BUILD_TESTS=OFF
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

    find_program(TMP_COMMAND protoc ${TMP_INST_DIR}/bin)
    set(PROTOC_COMMAND ${TMP_COMMAND} PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${NBLA_PROTOBUF_DIR}/build.cmake)
    find_program(PROTOC_COMMAND protoc ${NBLA_PROTOBUF_DIR}/build.cmake PARENT_SCOPE)
  endif()

  Find_Package(Protobuf REQUIRED)

  if(NOT Protobuf_FOUND)
    error_abort()
  else()
    message("  <<build_protobuf>>")
    message("  PROTOBUF_INCLUDE_DIR = " ${PROTOBUF_INCLUDE_DIR})
    message("      PROTOBUF_LIBRARY = " ${PROTOBUF_LIBRARY})
    message("        PROTOC_COMMAND = " ${TMP_COMMAND})
  endif()

endfunction()


# =============================================================================
# bzip2
function(build_bzip2 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  else()
  endif()

  Find_Package(BZip2 REQUIRED)

  if(NOT BZip2_FOUND)
    error_abort()
  else()
    message("  <<build_bzip2>>")
    message("  BZIP2_INCLUDE_DIR = " ${BZIP2_INCLUDE_DIR})
    message("      BZIP2_LIBRARY = " ${BZIP2_LIBRARY})
  endif()

endfunction()


# =============================================================================
# lz4
function(build_lz4 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ../build/cmake
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  else()
  endif()

  Find_Package(LZ4 REQUIRED)

  if(NOT LZ4_FOUND)
    error_abort()
  else()
    message("  <<build_lz4>>")
    message("  LZ4_INCLUDE_DIR = " ${LZ4_INCLUDE_DIR})
    message("      LZ4_LIBRARY = " ${LZ4_LIBRARY})
  endif()

endfunction()


# =============================================================================
# zlib
function(build_zlib NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ..
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  else()
  endif()

  set(ZLIB_ROOT ${TMP_INST_DIR})
  Find_Package(ZLIB REQUIRED)
  set(ZLIB_ROOT ${TMP_INST_DIR} PARENT_SCOPE)

  if(NOT ZLIB_FOUND)
    error_abort()
  else()
    message("  <<build_zlib>>")
    message("  ZLIB_INCLUDE_DIR = " ${ZLIB_INCLUDE_DIR})
    message("      ZLIB_LIBRARY = " ${ZLIB_LIBRARY})
  endif()

endfunction()


# =============================================================================
# zstd
function(build_zstd NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ../build/cmake
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake --build . --config Release
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
    execute_process(
      COMMAND cmake --install .
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

    set(TMP_INC_DIR ${TMP_BASE_DIR}/lib)
    set(TMP_LIB ${TMP_BASE_DIR}/build.cmake/lib/Release/zstd.lib)
    #set(TMP_LIB ${TMP_BASE_DIR}/build.cmake/lib/Release/zstd_static.lib)
    
    set(PC_ZSTD_INCLUDEDIR ${TMP_INC_DIR} PARENT_SCOPE)
    set(PC_ZSTD_LIBDIR ${TMP_LIB} PARENT_SCOPE)

  else()
    execute_process(
      COMMAND make
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  endif()

  Find_Package(ZSTD REQUIRED)

  if(NOT ZSTD_FOUND)
    error_abort()
  else()
    message("  <<build_zstd>>")
    message("  PC_ZSTD_INCLUDEDIR = " ${TMP_INC_DIR})
    message("      PC_ZSTD_LIBDIR = " ${TMP_LIB})
  endif()

endfunction()
