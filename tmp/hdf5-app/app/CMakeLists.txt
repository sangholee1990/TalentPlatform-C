cmake_minimum_required (VERSION 3.2.2)
project (HDF5Examples C CXX)

#-----------------------------------------------------------------------------
# Instructions for use : Normal Build
#
# For standard build of HDF5 examples.
#-----------------------------------------------------------------------------
set (CMAKE_NO_SYSTEM_FROM_IMPORTED 1)

#-----------------------------------------------------------------------------
# Allow Visual Studio solution directories
#-----------------------------------------------------------------------------
# Provide a way for Visual Studio Express users to turn OFF the new FOLDER
# organization feature. Default to ON for non-Express users. Express users must
# explicitly turn off this option to build HDF5 in the Express IDE...
#
option (HDF5_USE_FOLDERS "Enable folder grouping of projects in IDEs." ON)
mark_as_advanced (HDF5_USE_FOLDERS)
if (HDF5_USE_FOLDERS)
  set_property (GLOBAL PROPERTY USE_FOLDERS ON)
endif ()

#-----------------------------------------------------------------------------
# Define some CMake variables for use later in the project
#-----------------------------------------------------------------------------
set (HDF5_RESOURCES_DIR      ${PROJECT_SOURCE_DIR}/config/cmake)
set (HDF5_C_SRC_DIR          ${PROJECT_SOURCE_DIR}/C)
set (HDF5_F90_SRC_DIR        ${PROJECT_SOURCE_DIR}/FORTRAN)
set (HDF5_JAVA_DIR           ${PROJECT_SOURCE_DIR}/JAVA)

if (HDF_BUILD_JAVA)
  find_package (Java)
endif ()

#-----------------------------------------------------------------------------
# Include some macros for reusable code
#-----------------------------------------------------------------------------
include (${HDF5_RESOURCES_DIR}/HDFMacros.cmake)
include (${HDF5_RESOURCES_DIR}/HDF5Macros.cmake)

#-----------------------------------------------------------------------------
# Setup output Directories
#-----------------------------------------------------------------------------
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all Executables."
)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all Libraries"
)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all static libraries."
)
set (CMAKE_Fortran_MODULE_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all fortran modules."
)
set (CMAKE_JAVA_TARGET_OUTPUT_DIR
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all java jars."
)
set (CMAKE_PDB_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin CACHE PATH "Single Directory for all pdb files."
)

#-----------------------------------------------------------------------------
# When building utility executables that generate other (source) files :
# we make use of the following variables defined in the root CMakeLists.
# Certain systems may add /Debug or /Release to output paths
# and we need to call the executable from inside the CMake configuration
#-----------------------------------------------------------------------------
set (EXE_EXT "")
if (WIN32)
  set (EXE_EXT ".exe")
  add_definitions (-D_BIND_TO_CURRENT_VCLIBS_VERSION=1)
  add_definitions (-D_CRT_SECURE_NO_WARNINGS)
  add_definitions (-D_CONSOLE)
endif ()

if (MSVC)
  set (CMAKE_MFC_FLAG 0)
endif ()

set (MAKE_SYSTEM)
if (CMAKE_BUILD_TOOL MATCHES "make")
  set (MAKE_SYSTEM 1)
endif ()

set (CFG_INIT "/${CMAKE_CFG_INTDIR}")
if (MAKE_SYSTEM)
  set (CFG_INIT "")
endif ()


if (HDF_BUILD_JAVA)
  INCLUDE_DIRECTORIES (
      ${JAVA_INCLUDE_PATH}
      ${JAVA_INCLUDE_PATH2}
  )
  set (CMAKE_JAVA_INCLUDE_PATH "")
endif ()

#-----------------------------------------------------------------------------
# Compiler specific flags : Shouldn't there be compiler tests for these
#-----------------------------------------------------------------------------
if (CMAKE_COMPILER_IS_GNUCC)
  set (CMAKE_C_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_C_FLAGS} -std=c99 -fomit-frame-pointer -finline-functions -fno-common")
endif ()
if (CMAKE_COMPILER_IS_GNUCXX)
  set (CMAKE_CXX_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_CXX_FLAGS} -fomit-frame-pointer -finline-functions -fno-common")
endif ()

#-----------------------------------------------------------------------------
# HDF5 support
#-----------------------------------------------------------------------------
set (CMAKE_MODULE_PATH ${HDF5_RESOURCES_DIR} ${CMAKE_MODULE_PATH})

if (NOT HDF5_HDF5_HEADER)
  if (BUILD_SHARED_LIBS)
    set (FIND_HDF_COMPONENTS C shared)
  else ()
    set (FIND_HDF_COMPONENTS C static)
  endif ()
  if (HDF_BUILD_FORTRAN)
    set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Fortran)
  endif ()
  if (HDF_BUILD_JAVA)
    set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Java)
  endif ()
  message (STATUS "HDF5 find comps: ${FIND_HDF_COMPONENTS}")
  set (SEARCH_PACKAGE_NAME ${HDF5_PACKAGE_NAME})

  find_package (HDF5 NAMES ${SEARCH_PACKAGE_NAME} COMPONENTS ${FIND_HDF_COMPONENTS})
  message (STATUS "HDF5 C libs:${HDF5_FOUND} static:${HDF5_static_C_FOUND} and shared:${HDF5_shared_C_FOUND}")
  message (STATUS "HDF5 Fortran libs: static:${HDF5_static_Fortran_FOUND} and shared:${HDF5_shared_Fortran_FOUND}")
  message (STATUS "HDF5 Java libs: static:${HDF5_static_Java_FOUND} and shared:${HDF5_shared_Java_FOUND}")
  if (HDF5_FOUND)
    if (NOT TARGET hdf5::h5dump)
        add_executable (hdf5::h5dump IMPORTED)
    endif()
    if (NOT HDF5_static_C_FOUND AND NOT HDF5_shared_C_FOUND)
      set (FIND_HDF_COMPONENTS C)
      if (HDF_BUILD_FORTRAN)
        set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Fortran)
      endif ()
      if (HDF_BUILD_JAVA)
        set (FIND_HDF_COMPONENTS ${FIND_HDF_COMPONENTS} Java)
      endif ()
      message (STATUS "HDF5 find comps: ${FIND_HDF_COMPONENTS}")

      find_package (HDF5 NAMES ${SEARCH_PACKAGE_NAME} COMPONENTS ${FIND_HDF_COMPONENTS})
      message (STATUS "HDF5 libs:${HDF5_FOUND} C:${HDF5_C_FOUND} Fortran:${HDF5_Fortran_FOUND} Java:${HDF5_Java_FOUND}")
      set (LINK_LIBS ${LINK_LIBS} ${HDF5_LIBRARIES})
      if (HDF5_BUILD_SHARED_LIBS)
        add_definitions (-DH5_BUILT_AS_DYNAMIC_LIB)
      else ()
        add_definitions (-DH5_BUILT_AS_STATIC_LIB)
      endif ()
      if (BUILD_SHARED_LIBS AND WIN32)
        set_property (TARGET hdf5::h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dumpdll")
      else ()
        set_property (TARGET hdf5::h5dump PROPERTY IMPORTED_LOCATION "${HDF5_TOOLS_DIR}/h5dump")
      endif ()
      if (HDF_BUILD_JAVA)
        set (CMAKE_JAVA_INCLUDE_PATH "${CMAKE_JAVA_INCLUDE_PATH};${HDF5_JAVA_INCLUDE_DIRS}")
        message (STATUS "HDF5 jars:${HDF5_JAVA_INCLUDE_DIRS}}")
      endif ()
    else ()
      if (BUILD_SHARED_LIBS AND HDF5_shared_C_FOUND)
        set (LINK_LIBS ${LINK_LIBS} ${HDF5_C_SHARED_LIBRARY})
      else ()
        set (LINK_LIBS ${LINK_LIBS} ${HDF5_C_STATIC_LIBRARY})
      endif ()
      if (HDF_BUILD_FORTRAN)
        if (BUILD_SHARED_LIBS AND HDF5_shared_Fortran_FOUND)
          set (LINK_LIBS ${LINK_LIBS} ${HDF5_FORTRAN_SHARED_LIBRARY})
        else ()
          set (LINK_LIBS ${LINK_LIBS} ${HDF5_FORTRAN_STATIC_LIBRARY})
        endif ()
      endif ()
      if (HDF_BUILD_JAVA)
        set (CMAKE_JAVA_INCLUDE_PATH "${CMAKE_JAVA_INCLUDE_PATH};${HDF5_JAVA_INCLUDE_DIRS}")
        message (STATUS "HDF5 jars:${HDF5_JAVA_INCLUDE_DIRS}}")
      endif ()
    endif ()
    set (HDF5_DUMP_EXECUTABLE $<TARGET_FILE:hdf5::h5dump>)

    set (HDF5_HAVE_H5PUBCONF_H 1)
    set (HDF5_HAVE_HDF5 1)
    set (HDF5_HDF5_HEADER "h5pubconf.h")
    set (HDF5_INCLUDE_DIR_GEN ${HDF5_INCLUDE_DIR})
    message (STATUS "HDF5-${HDF5_VERSION_STRING} found: INC=${HDF5_INCLUDE_DIR} TOOLS=${HDF5_TOOLS_DIR}")
  else (HDF5_FOUND)
    message (FATAL_ERROR " HDF5 is Required for HDF5 Examples")
  endif (HDF5_FOUND)
  set (HDF5_PACKAGE_NAME ${SEARCH_PACKAGE_NAME})
else (NOT HDF5_HDF5_HEADER)
  # This project is being called from within another and HDF5 is already configured
  set (HDF5_HAVE_H5PUBCONF_H 1)
  set (HDF5_HAVE_HDF5 1)
endif (NOT HDF5_HDF5_HEADER)

INCLUDE_DIRECTORIES (${HDF5_INCLUDE_DIR})
if (HDF_BUILD_FORTRAN)
  INCLUDE_DIRECTORIES (${HDF5_INCLUDE_DIR_FORTRAN})
endif ()
message (STATUS "HDF5 link libs: ${LINK_LIBS}")
if (WIN32)
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_TOOLS_DIR}")
else ()
  set(CMAKE_TEST_LIB_DIRECTORY "${HDF5_LIBRARY_PATH}")
endif ()

#-----------------------------------------------------------------------------
# Option to use Shared/Static libs, default is static
#-----------------------------------------------------------------------------
set (LIB_TYPE STATIC)
if (BUILD_SHARED_LIBS)
  set (LIB_TYPE SHARED)
endif ()
set (CMAKE_POSITION_INDEPENDENT_CODE ON)

#-----------------------------------------------------------------------------
# Option to allow the user to disable compiler warnings
#-----------------------------------------------------------------------------
option (HDF_DISABLE_COMPILER_WARNINGS "Disable compiler warnings" OFF)
if (HDF_DISABLE_COMPILER_WARNINGS)
  # MSVC uses /w to suppress warnings.  It also complains if another
  # warning level is given, so remove it.
  if (MSVC)
    set (HDF_WARNINGS_BLOCKED 1)
    string (REGEX REPLACE "(^| )([/-])W[0-9]( |$)" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /w")
    string (REGEX REPLACE "(^| )([/-])W[0-9]( |$)" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /w")
  endif ()
  if (WIN32)
    add_definitions (-D_CRT_SECURE_NO_WARNINGS)
  endif ()
  # Borland uses -w- to suppress warnings.
  if (BORLAND)
    set (HDF_WARNINGS_BLOCKED 1)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w-")
  endif ()

  # Most compilers use -w to suppress warnings.
  if (NOT HDF_WARNINGS_BLOCKED)
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w")
  endif ()
endif ()

#-----------------------------------------------------------------------------
# This is in here to help some of the GCC based IDES like Eclipse
# and code blocks parse the compiler errors and warnings better.
#-----------------------------------------------------------------------------
if (CMAKE_COMPILER_IS_GNUCC)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fmessage-length=0")
endif ()
if (CMAKE_COMPILER_IS_GNUCXX)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=0")
endif ()

#-----------------------------------------------------------------------------
# All examples need the main include directories
#-----------------------------------------------------------------------------
INCLUDE_DIRECTORIES (${PROJECT_BINARY_DIR})

#-----------------------------------------------------------------------------
# Option to Enable MPI Parallel
#-----------------------------------------------------------------------------
set (CMAKE_MODULE_PATH ${HDF5_RESOURCES_DIR} ${CMAKE_MODULE_PATH})
option (HDF_ENABLE_PARALLEL "Enable parallel build (requires MPI)" OFF)
if (HDF_ENABLE_PARALLEL)
  include (FindMPI)
  INCLUDE_DIRECTORIES (${MPI_INCLUDE_PATH})
  if (MPI_FOUND)
    set (H5_HAVE_PARALLEL 1)
    # MPI checks, only do these if MPI_FOUND is true, otherwise they always fail
    # and once set, they are cached as false and not regenerated
    set (CMAKE_REQUIRED_LIBRARIES "${MPI_LIBRARY};${MPI_EXTRA_LIBRARY}" )
    CHECK_FUNCTION_EXISTS (MPI_File_get_size H5_HAVE_MPI_GET_SIZE)
    # Used by Fortran + MPI
    CHECK_SYMBOL_EXISTS (MPI_Comm_c2f "${MPI_INCLUDE_PATH}/mpi.h"  H5_HAVE_MPI_MULTI_LANG_Comm)
    CHECK_SYMBOL_EXISTS (MPI_Info_c2f "${MPI_INCLUDE_PATH}/mpi.h"  H5_HAVE_MPI_MULTI_LANG_Info)
  endif ()
endif ()

# Parallel IO usage requires MPI to be Linked and Included
if (H5_HAVE_PARALLEL)
  set (LINK_LIBS ${LINK_LIBS} ${MPI_LIBRARY})
  if (MPI_LINK_FLAGS)
    set (CMAKE_EXE_LINKER_FLAGS ${MPI_LINK_FLAGS} ${CMAKE_EXE_LINKER_FLAGS})
  endif ()
  if (MPI_EXTRA_LIBRARY)
    set (LINK_LIBS ${LINK_LIBS} ${MPI_EXTRA_LIBRARY})
  endif ()
endif ()

#-----------------------------------------------------------------------------
# Option to use threadsafe
# Note: Currently CMake only allows configuring of threadsafe on WINDOWS.
#-----------------------------------------------------------------------------
if (WIN32)
  option (HDF_ENABLE_THREADSAFE "Enable Threadsafety" OFF)
  if (HDF_ENABLE_THREADSAFE)
    # check for unsupported options
    if (HDF_ENABLE_PARALLEL)
      message (FATAL " **** Parallel and Threadsafe options are mutually exclusive **** ")
    endif ()
    set (H5_HAVE_WIN_THREADS 1)
    set (H5_HAVE_THREADSAFE 1)
  endif ()
endif ()

#-----------------------------------------------------------------------------
# Dashboard and Testing Settings
#-----------------------------------------------------------------------------
option (BUILD_TESTING "Build HDF5 Example Testing" OFF)
if (BUILD_TESTING)
  set (DART_TESTING_TIMEOUT 1200
      CACHE INTEGER
      "Timeout in seconds for each test (default 1200=20minutes)"
  )
  enable_testing ()
  include (CTest)
  include (${PROJECT_SOURCE_DIR}/CTestConfig.cmake)
  configure_file (${HDF5_RESOURCES_DIR}/CTestCustom.cmake ${PROJECT_BINARY_DIR}/CTestCustom.ctest @ONLY)
endif ()

#-----------------------------------------------------------------------------
# Build examples
#-----------------------------------------------------------------------------
add_subdirectory (${PROJECT_SOURCE_DIR}/C ${PROJECT_BINARY_DIR}/C)

#-----------------------------------------------------------------------------
# Option to build Fortran examples
# Make sure this appears before the CONFIGURE_FILE step
# so that fortran name mangling is detected before writing H5pubconf.h
#-----------------------------------------------------------------------------
# Set default name mangling : overridden by Fortran detection in fortran dir
set (H5_FC_FUNC  "H5_FC_FUNC(name,NAME) name ## _")
set (H5_FC_FUNC_ "H5_FC_FUNC_(name,NAME) name ## _")
if (EXISTS "${PROJECT_SOURCE_DIR}/FORTRAN" AND IS_DIRECTORY "${PROJECT_SOURCE_DIR}/FORTRAN")
  option (HDF_BUILD_FORTRAN "Build FORTRAN support" OFF)
  if (HDF_BUILD_FORTRAN AND HDF5_BUILD_FORTRAN)
    include (${HDF5_RESOURCES_DIR}/HDF5UseFortran.cmake)
    add_subdirectory (${PROJECT_SOURCE_DIR}/FORTRAN ${PROJECT_BINARY_DIR}/FORTRAN)
  endif ()
endif ()

#-----------------------------------------------------------------------------
# Option to build JAVA sources
#-----------------------------------------------------------------------------
if (EXISTS "${PROJECT_SOURCE_DIR}/Java" AND IS_DIRECTORY "${PROJECT_SOURCE_DIR}/Java")
  option (HDF_BUILD_JAVA "Build JAVA support" OFF)
  if (HDF_BUILD_JAVA AND HDF5_BUILD_JAVA)
    include (${HDF5_RESOURCES_DIR}/UseJava.cmake)
    add_subdirectory (${PROJECT_SOURCE_DIR}/Java ${PROJECT_BINARY_DIR}/Java)
  endif ()
endif ()

#-----------------------------------------------------------------------------
# Source Packaging Option
#-----------------------------------------------------------------------------
option (PACK_EXAMPLE_SOURCE "Package HDF5 Example Source File" OFF)
if (PACK_EXAMPLE_SOURCE)
  set(CPACK_SOURCE_IGNORE_FILES
      "^${PROJECT_SOURCE_DIR}/\\\\.git*"
      "^${PROJECT_SOURCE_DIR}/\\\\.project"
  )
  set (CPACK_PACKAGE_VENDOR "HDF_Group")
  set (CPACK_PACKAGE_NAME "HDF5Examples")
  set (CPACK_GENERATOR "TGZ")
  set (CPACK_SOURCE_GENERATOR "TGZ")
  if (WIN32)
    set (CPACK_GENERATOR "ZIP")
    set (CPACK_SOURCE_GENERATOR "ZIP")
  endif()
  set (CPACK_TOPLEVEL_TAG "HDF5Examples-${CPACK_PACKAGE_VERSION}-Source")
  set (CPACK_SOURCE_TOPLEVEL_TAG "HDF5Examples-${CPACK_PACKAGE_VERSION}-Source")
  set (CPACK_SOURCE_PACKAGE_FILE_NAME "HDF5Examples")
  INCLUDE(CPack)
  # Installation types
  cpack_add_install_type(Full DISPLAY_NAME "Everything")

  # Component groups
  cpack_add_component_group(Development
      EXPANDED
      DESCRIPTION "All of the examples to test HDF5 library"
  )
  cpack_add_component(source
      DISPLAY_NAME "Source Files"
      DESCRIPTION "Source files of HDF5 Library Examples"
      GROUP Development
      INSTALL_TYPES Full
  )
endif (PACK_EXAMPLE_SOURCE)
