find_package(tensorflow_catkin QUIET)

if(NOT tensorflow_catkin_FOUND)
  message(WARNING "tensorflow_catkin was not found")
  return()
endif()

set(TENSORFLOW_FOUND 1)
set(tensorflow_ros_INCLUDE_DIRS ${tensorflow_catkin_INCLUDE_DIRS} ${tensorflow_catkin_INCLUDE_DIRS}/external/nsync/public)
set(tensorflow_ros_LIBRARIES ${tensorflow_catkin_LIBRARIES})
set(tensorflow_ros_CATKIN_DEPENDS tensorflow_catkin)