set(TENSORFLOW_CUSTOM_LIBRARY ${CATKIN_DEVEL_PREFIX}/libtensorflow_cc.so)
if(EXISTS ${TENSORFLOW_CUSTOM_LIBRARY})
  message("Found custom libtensorflow_cc.so, using it.")
  set(TENSORFLOW_LIBRARY ${CATKIN_DEVEL_PREFIX}/lib/libtensorflow_cc.so)
  configure_file(${TENSORFLOW_CUSTOM_LIBRARY} ${TENSORFLOW_LIBRARY} COPYONLY)
  set(TENSORFLOW_LIBRARIES tensorflow_cc)
  set(TENSORFLOW_TARGETS ${TENSORFLOW_LIBRARY})
endif()

set(TENSORFLOW_CUSTOM_INCLUDE_DIR ${CATKIN_DEVEL_PREFIX}/tensorflow-include-base)
if(EXISTS ${TENSORFLOW_CUSTOM_INCLUDE_DIR})
  message("Found custom tensorflow-include-base, using it.")
  set(TENSORFLOW_INCLUDE_DIRS ${TENSORFLOW_CUSTOM_INCLUDE_DIR}/bazel-genfiles ${TENSORFLOW_CUSTOM_INCLUDE_DIR})

  # We need eigen
  find_package(Eigen3 REQUIRED)
  list(APPEND TENSORFLOW_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIRS})

  # Nsync
  get_filename_component(BAZEL_TENSORFLOW_DIR ${TENSORFLOW_CUSTOM_INCLUDE_DIR}/bazel-tensorflow REALPATH)
  message("bazel-tensorflow dir is ${BAZEL_TENSORFLOW_DIR}")
  get_filename_component(NSYNC_DIR ${BAZEL_TENSORFLOW_DIR}/../../external/nsync/public REALPATH)
  message("nsync dir is ${NSYNC_DIR}")
  list(APPEND TENSORFLOW_INCLUDE_DIRS ${NSYNC_DIR})
endif()

include(FindPkgConfig)
pkg_check_modules(Protobuf protobuf)
if (NOT Protobuf_FOUND)
  find_package(Protobuf REQUIRED)
endif()

set(tensorflow_ros_INCLUDE_DIRS ${TENSORFLOW_INCLUDE_DIRS} ${Protobuf_INCLUDE_DIRS})
set(tensorflow_ros_LIBRARIES ${TENSORFLOW_LIBRARIES} ${Protobuf_LIBRARIES})