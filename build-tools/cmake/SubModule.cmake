# 
include(${CMAKE_SOURCE_DIR}/build-tools/cmake/Download.cmake)


# =============================================================================
# libarchive
function(build_libarchive NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    set(LibArchive_BUILD_SHARED_LIBS ON)
  else(WIN32)
    set(LibArchive_BUILD_SHARED_LIBS OFF)
  endif(WIN32)

  execute_process(
    COMMAND cmake ..
            -DBUILD_SHARED_LIBS=${LibArchive_BUILD_SHARED_LIBS}
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DENABLE_MBEDTLS=OFF
            -DENABLE_NETTLE=OFF
            -DENABLE_OPENSSL=OFF
            -DENABLE_LIBB2=OFF
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

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    Find_Package(LibArchive REQUIRED)
  else()
    set(LibArchive_FOUND true)
    set(LibArchive_INCLUDE_DIR ${TMP_INST_DIR}/include)
    set(LibArchive_LIBRARIES ${TMP_INST_DIR}/lib/libarchive.a)
  endif()

  if(NOT LibArchive_FOUND)
    error_abort()
  else()
    message("  <<build_libarchive>>")
    message("  LibArchive_INCLUDE_DIR = " ${LibArchive_INCLUDE_DIR})
    message("    LibArchive_LIBRARIES = " ${LibArchive_LIBRARIES})
    if(NOT WIN32)
      set(LibArchive_INCLUDE_DIR ${TMP_INST_DIR}/include PARENT_SCOPE)
      set(LibArchive_LIBRARIES ${TMP_INST_DIR}/lib/libarchive.a PARENT_SCOPE)
    endif()
  endif()

endfunction()
# -DZLIB_ROOT=${ZLIB_ROOT}
#-DZSTD_INCLUDE_DIR=${NBLR_ZSTD_INCLUDE_DIR}
#-DZSTD_LIBRARY=${NBLR_ZSTD_LIBRARY}


# =============================================================================
# eigen
function(build_eigen NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  message("  <<build_eigen>>")
endfunction()


# =============================================================================
# hdf5
function(build_hdf5 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    set(BUILD_STATIC_LIBS OFF)
    set(BUILD_SHARED_LIBS ON)
    set(ONLY_SHARED_LIBS ON)
  else(WIN32)
    set(BUILD_STATIC_LIBS ON)
    set(BUILD_SHARED_LIBS OFF)
    set(ONLY_SHARED_LIBS OFF)
  endif(WIN32)

  execute_process(
    COMMAND cmake ..
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DBUILD_STATIC_LIBS=${BUILD_STATIC_LIBS}
            -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
            -DONLY_SHARED_LIBS=${ONLY_SHARED_LIBS}
            -DCPACK_SOURCE_ZIP=OFF
            -DHDF5_BUILD_HL_TOOLS=OFF
            -DHDF5_BUILD_TOOLS=OFF
            -DHDF5_BUILD_UTILS=OFF
            -DHDF5_BUILD_EXAMPLES=OFF
            #-DHDF5_TEST_CPP=OFF
            #-DHDF5_TEST_EXAMPLES=OFF
            #-DHDF5_TEST_JAVA=OFF
            #-DHDF5_TEST_TOOLS=OFF
            #-DHDF5_TEST_VFD=OFF
            #-DHDF5_TEST_SWMR=OFF
            #-DHDF5_TEST_PARALLEL=OFF
            -DHDF5_BUILD_HL_LIB=ON
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake --build . --config=Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  set(HDF5_FOUND true)
  set(HDF5_INCLUDE_DIR ${TMP_INST_DIR}/include)
  set(HDF5_INCLUDE_DIRS ${TMP_INST_DIR}/include)
  if(WIN32)
    set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/hdf5.lib ${TMP_INST_DIR}/lib/hdf5_hl.lib)
    set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/hdf5_hl.lib)
  else()
    set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5.a ${TMP_INST_DIR}/lib/libhdf5_hl.a)
    set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5_hl.a)
  endif(WIN32)

  if(NOT HDF5_FOUND)
    error_abort()
  else()
    message("  <<build_hdf5>>")
    message("         HDF5_FOUND = " ${HDF5_FOUND})
    message("   HDF5_INCLUDE_DIR = " ${HDF5_INCLUDE_DIR})
    message("  HDF5_INCLUDE_DIRS = " ${HDF5_INCLUDE_DIRS})
    message("     HDF5_LIBRARIES = " ${HDF5_LIBRARIES})
    message("  HDF5_HL_LIBRARIES = " ${HDF5_HL_LIBRARIES})
    set(HDF5_INCLUDE_DIR ${TMP_INST_DIR}/include PARENT_SCOPE)
    set(HDF5_INCLUDE_DIRS ${TMP_INST_DIR}/include PARENT_SCOPE)
    if(WIN32)
      set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/hdf5.lib ${TMP_INST_DIR}/lib/hdf5_hl.lib PARENT_SCOPE)
      set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/hdf5_hl.lib PARENT_SCOPE)
    else()
      set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5.a ${TMP_INST_DIR}/lib/libhdf5_hl.a PARENT_SCOPE)
      set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5_hl.a PARENT_SCOPE)
    endif(WIN32)
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
    COMMAND cmake ../cmake
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -Dprotobuf_MSVC_STATIC_RUNTIME=ON
            -Dprotobuf_BUILD_TESTS=OFF
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  find_program(TMP_COMMAND protoc ${TMP_INST_DIR}/bin)
  set(PROTOC_COMMAND ${TMP_COMMAND} PARENT_SCOPE)

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
# lz4
function(build_lz4 NAME EXT URL)
  download_and_extract_library(${NAME} ${EXT} ${URL} DIRECTORY)
  set(TMP_BASE_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/${NAME})
  set(TMP_INST_DIR ${NBLA_ROOT_CMAKE_DIR}/third_party/inst_${NAME})
  file(MAKE_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake ../build/cmake
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DBUILD_SHARED_LIBS=OFF
            -DBUILD_STATIC_LIBS=ON
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  Find_Package(lz4 REQUIRED)

  if(NOT lz4_FOUND)
    error_abort()
  else()
    message("  <<build_lz4>>")
    message("  lz4_INCLUDE_DIR = " ${lz4_INCLUDE_DIR})
    message("      lz4_LIBRARY = " ${lz4_LIBRARY})
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

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    Find_Package(ZLIB REQUIRED)
  else()
    set(ZLIB_FOUND true)
    set(ZLIB_INCLUDE_DIR ${TMP_INST_DIR}/include)
    set(ZLIB_LIBRARY ${TMP_INST_DIR}/lib/zlib.a)
  endif()

  if(NOT ZLIB_FOUND)
    error_abort()
  else()
    message("  <<build_zlib>>")
    message("  ZLIB_INCLUDE_DIR = " ${ZLIB_INCLUDE_DIR})
    message("      ZLIB_LIBRARY = " ${ZLIB_LIBRARY})
    if(NOT WIN32)
      set(ZLIB_FOUND true PARENT_SCOPE)
      set(ZLIB_INCLUDE_DIR ${TMP_INST_DIR}/include PARENT_SCOPE)
      set(ZLIB_LIBRARY ${TMP_INST_DIR}/lib/zlib.a PARENT_SCOPE)
    endif()
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
            -DZSTD_BUILD_SHARED=OFF
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    execute_process(
      COMMAND cmake -E copy
              ${TMP_INST_DIR}/lib/zstd_static.lib
              ${TMP_INST_DIR}/lib/zstd.lib
      WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  endif(WIN32)

  Find_Package(zstd REQUIRED)

  if(NOT zstd_FOUND)
    error_abort()
  else()
    message("  <<build_zstd>>")
  endif()

endfunction()
