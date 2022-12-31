cmake_minimum_required( VERSION 3.19 )

add_subdirectory( dyad )
add_subdirectory( lmdb )
add_subdirectory( mth )

# Set LWS options
# set(LWS_WITH_STATIC OFF CACHE BOOL "Disable static build" FORCE)
set(LWS_WITHOUT_CLIENT ON CACHE BOOL "Disable client build" FORCE)
set(LWS_WITHOUT_TESTAPPS ON CACHE BOOL "Disable testapps build" FORCE)
set(LWS_WITHOUT_TEST_SERVER ON CACHE BOOL "Disable test server build" FORCE)

add_subdirectory( libwebsockets )
