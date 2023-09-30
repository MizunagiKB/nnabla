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

  execute_process(
    COMMAND cmake ..
            -DCMAKE_INSTALL_PREFIX=${TMP_INST_DIR}
            -DBUILD_STATIC_LIBS=ON
            -DONLY_SHARED_LIBS=OFF
            -DBUILD_SHARED_LIBS=OFF
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

  if(WIN32)
    #set(HDF5_ROOT ${TMP_INST_DIR})
    Find_Package(HDF5 COMPONENTS C HL REQUIRED)
    #set(HDF5_ROOT ${TMP_INST_DIR} PARENT_SCOPE)
  else()
    set(HDF5_FOUND true)
    set(HDF5_INCLUDE_DIR ${TMP_INST_DIR}/include)
    set(HDF5_INCLUDE_DIRS ${TMP_INST_DIR}/include)
    set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5.a ${TMP_INST_DIR}/lib/libhdf5_hl.a)
    set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5_hl.a)
  endif()

  if(NOT HDF5_FOUND)
    error_abort()
  else()
    message("  <<build_hdf5>>")
    message("   HDF5_INCLUDE_DIR = " ${HDF5_INCLUDE_DIR})
    message("  HDF5_INCLUDE_DIRS = " ${HDF5_INCLUDE_DIRS})
    message("     HDF5_LIBRARIES = " ${HDF5_LIBRARIES})
    message("  HDF5_HL_LIBRARIES = " ${HDF5_HL_LIBRARIES})
    if(NOT WIN32)
      set(HDF5_INCLUDE_DIR ${TMP_INST_DIR}/include PARENT_SCOPE)
      set(HDF5_INCLUDE_DIRS ${TMP_INST_DIR}/include PARENT_SCOPE)
      set(HDF5_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5.a ${TMP_INST_DIR}/lib/libhdf5_hl.a PARENT_SCOPE)
      set(HDF5_HL_LIBRARIES ${TMP_INST_DIR}/lib/libhdf5_hl.a PARENT_SCOPE)
    endif()
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
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  Find_Package(LZ4)

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

  execute_process(
    COMMAND cmake --build . --config Release
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)
  execute_process(
    COMMAND cmake --install .
    WORKING_DIRECTORY ${TMP_BASE_DIR}/build.cmake)

  if(WIN32)
    #set(ZLIB_ROOT ${TMP_INST_DIR})
    Find_Package(ZLIB REQUIRED)
    #set(ZLIB_ROOT ${TMP_INST_DIR} PARENT_SCOPE)
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
      set(ZLIB_FOUND true)
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

  set(TMP_INC_DIR ${TMP_BASE_DIR}/lib)
  set(TMP_LIB ${TMP_BASE_DIR}/build.cmake/lib/Release/zstd.lib)
  #set(TMP_LIB ${TMP_BASE_DIR}/build.cmake/lib/Release/zstd_static.lib)
  
  set(PC_ZSTD_INCLUDEDIR ${TMP_INC_DIR} PARENT_SCOPE)
  set(PC_ZSTD_LIBDIR ${TMP_LIB} PARENT_SCOPE)

  Find_Package(ZSTD REQUIRED)

  if(NOT ZSTD_FOUND)
    error_abort()
  else()
    message("  <<build_zstd>>")
    message("  PC_ZSTD_INCLUDEDIR = " ${TMP_INC_DIR})
    message("      PC_ZSTD_LIBDIR = " ${TMP_LIB})
  endif()

endfunction()
