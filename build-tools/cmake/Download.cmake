################################################################################################
# Download dependencies source
#
function(download_and_extract_library NAME EXT URL TYPE)
  if((NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/third_party/${NAME} AND ${TYPE} STREQUAL "DIRECTORY") OR
    (NOT EXISTS ${CMAKE_SOURCE_DIR}/third_party/${NAME} AND ${TYPE} STREQUAL "BINARY"))
    message("Downloading ${NAME}")
    file(DOWNLOAD
      ${URL}
      ${CMAKE_SOURCE_DIR}/third_party/${NAME}${EXT}
      SHOW_PROGRESS
      STATUS status
      LOG log)
    list(GET status 0 status_code)
    list(GET status 1 status_string)

    if(NOT status_code EQUAL 0)
      if(UNIX OR APPLE)
        message("Failed to download ${NAME}. Try to download with wget.")
        execute_process(
          COMMAND wget ${WGET_OPTS} ${URL} -O ${CMAKE_SOURCE_DIR}/third_party/${NAME}${EXT})
      else()
        message(FATAL_ERROR "Failed to download ${NAME}. Please check network connection and proxy settings.
        status_code: ${status_code}
        status_string: ${status_string}
        log: ${log}
        ")
        error() # Place Unknown command to stop cmake process here.
      endif()
    endif()

    execute_process(
      COMMAND ${CMAKE_COMMAND} -E
      chdir ${CMAKE_SOURCE_DIR}/third_party
      ${CMAKE_COMMAND} -E tar xf ${NAME}${EXT})

  endif()
endfunction()