cmake_minimum_required( VERSION 3.12 )

add_subdirectory( dyad )
add_subdirectory( lmdb )
add_subdirectory( mth )

# Set LWS options
# set(LWS_WITH_STATIC OFF CACHE BOOL "Disable static build" FORCE)
set(LWS_WITHOUT_CLIENT ON CACHE BOOL "Disable client build" FORCE)
set(LWS_WITHOUT_TESTAPPS ON CACHE BOOL "Disable testapps build" FORCE)
set(LWS_WITHOUT_TEST_SERVER ON CACHE BOOL "Disable test server build" FORCE)
set(LWS_LOGS_TIMESTAMP OFF CACHE BOOL "Disable log timestamps" FORCE)

add_subdirectory( libwebsockets )

# This will build but Visual Studio won't see the header files
add_library( jsmn INTERFACE )
# This fix to the above is to use the trick below with cmake 3.19 or later
# add_library( jsmn INTERFACE jsmn/jsmn.h )
target_include_directories( jsmn INTERFACE jsmn/ )
