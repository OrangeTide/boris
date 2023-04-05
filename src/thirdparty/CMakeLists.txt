cmake_minimum_required( VERSION 3.12 )

add_subdirectory( dyad )
add_subdirectory( lmdb )
add_subdirectory( mth )
add_subdirectory( mongoose )

# This will build but Visual Studio won't see the header files
add_library( jsmn INTERFACE )
# This fix to the above is to use the trick below with cmake 3.19 or later
# add_library( jsmn INTERFACE jsmn/jsmn.h )
target_include_directories( jsmn INTERFACE jsmn/ )
