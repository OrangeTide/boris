if(DEFINED ENV{WEB_INSTALL_DIR})
  set(WEB_INSTALL_DIR "${CMAKE_SOURCE_DIR}/$ENV{WEB_INSTALL_DIR}")
else()
  set(WEB_INSTALL_DIR "${CMAKE_SOURCE_DIR}/bin/www")
endif()

# Install all files from within client/ directory preserving directory structure
# excluding assets dir
list(APPEND WEB_INSTALL_DIRS
  client/
)
install(DIRECTORY ${WEB_INSTALL_DIRS}
  DESTINATION "${WEB_INSTALL_DIR}"
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
  DESTINATION "${WEB_INSTALL_DIR}/assets"
)
install(DIRECTORY client/assets/fonts client/assets/icon
  DESTINATION "${WEB_INSTALL_DIR}/assets")
