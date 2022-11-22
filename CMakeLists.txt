project( boris C )
cmake_minimum_required( VERSION 3.12 )

if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
	message( FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt." )
endif()

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin )

set( CMAKE_BUILD_TYPE Debug )

SET( CMAKE_AR "gcc-ar" )
SET( CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>"  )
SET( CMAKE_C_ARCHIVE_FINISH true )

set( THREADS_PREFER_PTHREAD_FLAG ON )
find_package( Threads REQUIRED )

include(CheckIPOSupported)
check_ipo_supported(RESULT result)
if(result)
	set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()

add_subdirectory( src )
include_directories( src )


