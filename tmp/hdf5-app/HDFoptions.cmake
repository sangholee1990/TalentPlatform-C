#############################################################################################
####  Change default configuration of options in config/cmake/cacheinit.cmake file        ###
####  format: set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DXXX:YY=ZZZZ")                 ###
####  DEFAULT:                                                                            ###
####         BUILD_SHARED_LIBS:BOOL=OFF                                                   ###
####         HDF_BUILD_C:BOOL=ON                                                          ###
####         HDF_BUILD_CXX:BOOL=OFF                                                       ###
####         HDF_BUILD_FORTRAN:BOOL=OFF                                                   ###
####         HDF_BUILD_JAVA:BOOL=OFF                                                      ###
####         BUILD_TESTING:BOOL=OFF                                                       ###
####         HDF_ENABLE_PARALLEL:BOOL=OFF                                                 ###
####         HDF_ENABLE_THREADSAFE:BOOL=OFF                                               ###
#############################################################################################

### uncomment/comment and change the following lines for other configuration options
### build with shared libraries
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DBUILD_SHARED_LIBS:BOOL=ON")

#############################################################################################
####      languages       ####
### disable C builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_BUILD_C:BOOL=OFF")

### enable C++ builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_BUILD_CXX:BOOL=ON")

### enable Fortran builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_BUILD_FORTRAN:BOOL=ON")

### enable JAVA builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_BUILD_JAVA:BOOL=ON")

#############################################################################################
### enable parallel program builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_ENABLE_PARALLEL:BOOL=ON")


#############################################################################################
### enable threadsafe program builds
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DHDF_ENABLE_THREADSAFE:BOOL=ON")


#############################################################################################
### enable test program builds, requires reference files in testfiles subdirectory
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DBUILD_TESTING:BOOL=ON")
#set(ADD_BUILD_OPTIONS "${ADD_BUILD_OPTIONS} -DCOMPARE_TESTING:BOOL=ON")

#############################################################################################
