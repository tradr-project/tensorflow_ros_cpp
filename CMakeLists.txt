cmake_minimum_required(VERSION 2.8.3)
project(tensorflow_ros)

find_package(catkin REQUIRED)

find_package( PythonLibs 2.7 REQUIRED )
find_package( PythonInterp 2.7 REQUIRED )

# check for a modern c++ compiler, since tensorflow needs support for the c++11 standard
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
if(NOT COMPILER_SUPPORTS_CXX11)
	message(FATAL_ERROR "You must use a compiler that supports the c++11 standard, e.g. GCC 4.9.")
endif()

# try finding tensorflow with pip
execute_process(
	COMMAND pip show tensorflow
	RESULT_VARIABLE PIP_DIDNT_FIND_TENSORFLOW
	OUTPUT_VARIABLE PIP_SHOW_OUTPUT	
)

# find the tensorflow path using some heuristics
set(TENSORFLOW_FOUND 0)
if(DEFINED ENV{TENSORFLOW_PATH})
	# if TENSORFLOW_PATH env var is defined, give it precedence
	if(EXISTS $ENV{TENSORFLOW_PATH})
		set(TENSORFLOW_PATH "$ENV{TENSORFLOW_PATH}")
		set(TENSORFLOW_FOUND 1)
		message("Found user-specified tensorflow: ${TENSORFLOW_PATH}")
	else()
		message(WARNING "User-specified tensorflow from TENSORFLOW_PATH not found: $ENV{TENSORFLOW_PATH}")
	endif()
elseif(NOT PIP_DIDNT_FIND_TENSORFLOW)
	# parse pip output in case it found tensorflow
	string(REGEX MATCH "Location: [^\r\n]*[\r\n]" TENSORFLOW_LOCATION ${PIP_SHOW_OUTPUT})
	string(REGEX REPLACE "^Location: (.*)[\r\n]$" "\\1" TENSORFLOW_LOCATION2 ${TENSORFLOW_LOCATION})
	set(TENSORFLOW_PATH "${TENSORFLOW_LOCATION2}/tensorflow")
	set(TENSORFLOW_FOUND 1)
	message("Found pip-installed tensorflow: ${TENSORFLOW_PATH}")
else()
	# try finding tensorflow on the PYTHON_PACKAGE_PATH and a few other system paths
	find_path(TENSORFLOW_LOCATION tensorflow 
		PATHS ENV PYTHON_PACKAGE_PATH /usr/local/lib/python2.7/dist-packages /usr/lib/python2.7/dist-packages $ENV{HOME}/.local/lib/python2.7/site-packages
		NO_DEFAULT_PATH
	)
	if(${TENSORFLOW_LOCATION} MATCHES NOTFOUND)
		message(WARNING "Tensorflow not found")
	else()
		set(TENSORFLOW_PATH "${TENSORFLOW_LOCATION}/tensorflow")
		set(TENSORFLOW_FOUND 1)
		message("Found tensorflow: ${TENSORFLOW_PATH}")
	endif()
endif()

if(NOT ${TENSORFLOW_FOUND})
	message(FATAL_ERROR "Tensorflow could not be found. Try installing it manually using 'pip install --user tensorflow', or set the TENSORFLOW_PATH environment variable to point to the *dist-pacakges/tensorflow directory.")
endif()

# we need to add the `lib` prefix to the library name so that the linker can find it!
# first, test for presence of the Tensorflow 1.1+ library
set(TENSORFLOW_ORIG_LIBRARY ${TENSORFLOW_PATH}/python/_pywrap_tensorflow_internal${CMAKE_SHARED_LIBRARY_SUFFIX})
if(NOT EXISTS ${TENSORFLOW_ORIG_LIBRARY})
	# otherwise, use the filename used formerly
	set(TENSORFLOW_ORIG_LIBRARY ${TENSORFLOW_PATH}/python/_pywrap_tensorflow${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()

if(EXISTS ${TENSORFLOW_ORIG_LIBRARY})
	message("Using Tensorflow library ${TENSORFLOW_ORIG_LIBRARY}")
else()
	message(FATAL_ERROR "Tensorflow library _pywrap_tensorflow(_internal) not found in ${TENSORFLOW_PATH}")
endif()

set(TENSORFLOW_LIBRARY ${CATKIN_DEVEL_PREFIX}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}_pywrap_tensorflow${CMAKE_SHARED_LIBRARY_SUFFIX})
if(NOT EXISTS ${TENSORFLOW_LIBRARY})
	file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib)
	execute_process(
		COMMAND ln -s ${TENSORFLOW_ORIG_LIBRARY} ${TENSORFLOW_LIBRARY}
		RESULT_VARIABLE LINK_FAILED
		OUTPUT_QUIET
	)
	if(NOT LINK_FAILED)
		message("Created tensorflow library link ${TENSORFLOW_ORIG_LIBRARY} -> ${TENSORFLOW_LIBRARY}.")
	else()
		message(FATAL_ERROR "Could not create symlink from ${TENSORFLOW_ORIG_LIBRARY} -> ${TENSORFLOW_LIBRARY}.")
	endif()
endif()

catkin_package(
	INCLUDE_DIRS ${TENSORFLOW_PATH}/include
	LIBRARIES _pywrap_tensorflow python2.7  # yes, we also need to link against python...
	CFG_EXTRAS tensorflow-extras.cmake  # to add the c++11 compiler flag
)

add_custom_target(run ALL DEPENDS ${TENSORFLOW_LIBRARY})

install(
	FILES ${TENSORFLOW_LIBRARY}
	DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
)
