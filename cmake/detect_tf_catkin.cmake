find_package(tensorflow_catkin QUIET)

if(NOT tensorflow_catkin_FOUND)
  message(WARNING "tensorflow_catkin was not found")
  return()
endif()

message("-- -- Found tensorflow_catkin")

set(HAS_TENSORFLOW_GPU 0)
foreach(lib IN LISTS tensorflow_catkin_LIBRARIES)
  if(NOT "${lib}" MATCHES "^/")
    find_library(lib ${lib} PATHS ${tensorflow_catkin_LIBRARY_DIRS})
  endif()
  execute_process(
      COMMAND ldd "${lib}"
      OUTPUT_VARIABLE LDD_OUTPUT
  )
  if(${LDD_OUTPUT} MATCHES "libcudart.so")
    set(HAS_TENSORFLOW_GPU 1)
    break()
  endif()
endforeach()

if(${HAS_TENSORFLOW_GPU})
  message("-- -- The Tensorflow library is compiled with CUDA support.")
else()
  message("-- -- The Tensorflow library is compiled without CUDA support.")
endif()

# cuSOLVER from CUDA >= 8.0 requires OpenMP
set(ADDITIONAL_LIBS "")
if(${HAS_TENSORFLOW_GPU})
  if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" )
    set(ADDITIONAL_LIBS gomp)
  endif()
endif()

set(TENSORFLOW_FOUND 1)
set(tensorflow_ros_INCLUDE_DIRS ${tensorflow_catkin_INCLUDE_DIRS} ${tensorflow_catkin_INCLUDE_DIRS}/external/nsync/public)
set(tensorflow_ros_LIBRARIES ${tensorflow_catkin_LIBRARIES} ${ADDITIONAL_LIBS})
set(tensorflow_ros_CATKIN_DEPENDS tensorflow_catkin)