# Install all files from within client/ directory preserving directory structure
# excluding assets dir
list(APPEND WEB_INSTALL_DIRS
  client/
)
install(DIRECTORY ${WEB_INSTALL_DIRS}
  DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/www"
  PATTERN "client/assets" EXCLUDE
)

# Install assets from common folder and specified WEB_ASSET_FOLDER
file(GLOB WEB_INSTALL_ASSET_FILES
  LIST_DIRECTORIES false
  client/assets/*
  client/assets/${WEB_ASSET_FOLDER}/*
  client/assets/${WEB_ASSET_FOLDER}/**/*
)
install(FILES ${WEB_INSTALL_ASSET_FILES}
  DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/www/assets/"
)
