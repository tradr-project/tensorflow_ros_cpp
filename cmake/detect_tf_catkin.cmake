find_package(tensorflow_catkin)

if(NOT tensorflow_catkin_FOUND)
  message(WARNING "tensorflow_catkin was not found")
  return()
endif()

execute_process(
    COMMAND ${CMAKE_CXX_COMPILER} -print-libgcc-file-name
    OUTPUT_VARIABLE GCC_FILENAME
)
get_filename_component(GCC_LIB_DIR ${GCC_FILENAME} DIRECTORY)
#execute_process(COMMAND ln -sf ${GCC_LIB_DIR}/libgcc.a ${CATKIN_DEVEL_PREFIX}/lib/libgcc.a)
#execute_process(COMMAND ln -sf ${GCC_LIB_DIR}/libgcc_s.so ${CATKIN_DEVEL_PREFIX}/lib/libgcc_s.so)

set(TENSORFLOW_FOUND 1)
set(tensorflow_ros_INCLUDE_DIRS ${tensorflow_catkin_INCLUDE_DIRS})
set(tensorflow_ros_LIBRARIES ${tensorflow_catkin_LIBRARIES})
set(tensorflow_ros_CATKIN_DEPENDS tensorflow_catkin)