find_package(tensorflow_catkin QUIET)

if(NOT tensorflow_catkin_FOUND)
  message(WARNING "tensorflow_catkin was not found")
  return()
endif()

message("-- -- Found tensorflow_catkin")

# cuSOLVER from CUDA >= 8.0 requires OpenMP
set(ADDITIONAL_LIBS "")
if(NOT (${CUDA_VERSION_MAJOR} LESS 8))
  if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" )
    set(ADDITIONAL_LIBS gomp)
  endif()
endif()

set(TENSORFLOW_FOUND 1)
set(tensorflow_ros_INCLUDE_DIRS ${tensorflow_catkin_INCLUDE_DIRS} ${tensorflow_catkin_INCLUDE_DIRS}/external/nsync/public)
set(tensorflow_ros_LIBRARIES ${tensorflow_catkin_LIBRARIES} ${ADDITIONAL_LIBS})
set(tensorflow_ros_CATKIN_DEPENDS tensorflow_catkin)