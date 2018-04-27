if(EXISTS ${TF_BAZEL_LIBRARY})
  message("-- -- Found bazel-compiled libtensorflow_cc.so, using it.")
  set(TENSORFLOW_LIBRARY ${CATKIN_DEVEL_PREFIX}/lib/libtensorflow_cc.so)
  if(NOT EXISTS ${TENSORFLOW_LIBRARY})
    file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib)
    execute_process(
        COMMAND ln -s ${TF_BAZEL_LIBRARY} ${TENSORFLOW_LIBRARY}
        RESULT_VARIABLE LINK_FAILED
        OUTPUT_QUIET
    )
    if("${LINK_FAILED}" STREQUAL "0")
      message("-- -- Created tensorflow library link ${TF_BAZEL_LIBRARY} -> ${TENSORFLOW_LIBRARY}.")
    else()
      message(WARNING "-- -- Could not create symlink from ${TF_BAZEL_LIBRARY} -> ${TENSORFLOW_LIBRARY}.")
      return()
    endif()
  endif()
  set(TENSORFLOW_LIBRARIES tensorflow_cc)
  set(TENSORFLOW_TARGETS ${TENSORFLOW_LIBRARY})
else()
  message(WARNING "Bazel-compiled Tensorflow library ${TF_BAZEL_LIBRARY} not found.")
  return()
endif()

if(EXISTS ${TF_BAZEL_SRC_DIR})
  message("-- -- Found Tensorflow sources dir ${TF_BAZEL_SRC_DIR}.")
  set(TENSORFLOW_INCLUDE_DIRS ${TF_BAZEL_SRC_DIR}/bazel-genfiles ${TF_BAZEL_SRC_DIR})

  set(BAZEL_TF_DIR ${TF_BAZEL_SRC_DIR}/bazel-tensorflow)
  set(HAS_TENSORFLOW_GPU 0)
  if(NOT EXISTS ${BAZEL_TF_DIR})
    set(BAZEL_TF_DIR ${TF_BAZEL_SRC_DIR}/bazel-tensorflow-gpu)
    set(HAS_TENSORFLOW_GPU 1)
  endif()

  if(NOT ${TF_BAZEL_USE_SYSTEM_PROTOBUF})
    list(APPEND TENSORFLOW_INCLUDE_DIRS ${BAZEL_TF_DIR}/external/protobuf_archive/src)
  endif()
  list(APPEND TENSORFLOW_INCLUDE_DIRS ${BAZEL_TF_DIR}/external/eigen_archive)
  list(APPEND TENSORFLOW_INCLUDE_DIRS ${BAZEL_TF_DIR}/external/nsync/public)

  # detect protoc version
  set(TF_BAZEL_PROTOC_DIR ${TF_BAZEL_SRC_DIR}/bazel-out/host/bin/external/protobuf_archive)
  set(TF_BAZEL_PROTOC ${TF_BAZEL_PROTOC_DIR}/protoc)
  execute_process(
      COMMAND ${TF_BAZEL_PROTOC} --version
      RESULT_VARIABLE PROTOC_FAILED
      OUTPUT_VARIABLE PROTOC_VERSION_OUTPUT
  )
  if(NOT "${PROTOC_FAILED}" STREQUAL "0")
    message(WARNING "-- -- Compiled version of protoc not found.")
    return()
  endif()
  message("-- -- Using protobuf compiler ${PROTOC_VERSION_OUTPUT}, you should compile your code with the same version of protoc.")
  message("-- -- You can do it by using 'export PATH=${TF_BAZEL_PROTOC_DIR}:\$PATH'")
else()
  message(WARNING "Tensorflow sources dir ${TF_BAZEL_SRC_DIR} not found.")
  return()
endif()

# Allow finding Protobuf using pkg-config first, which is easier to point to a custom installation
include(FindPkgConfig)
pkg_check_modules(Protobuf protobuf)
if (NOT ${Protobuf_FOUND})
  find_package(Protobuf)
endif()
if(NOT ${Protobuf_FOUND})
  message(WARNING "-- -- Protobuf library not found")
  return()
endif()

set(TENSORFLOW_FOUND 1)
set(tensorflow_ros_INCLUDE_DIRS ${TENSORFLOW_INCLUDE_DIRS} ${Protobuf_INCLUDE_DIRS})
set(tensorflow_ros_LIBRARIES ${TENSORFLOW_LIBRARIES} ${Protobuf_LIBRARIES})
