^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package tensorflow_ros_cpp
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Forthcoming
-----------
* Switch to Github Actions CI
* Noetic and TF2 support
* Removed support for TF 1.15 on Indigo as it is known to have problems and Indigo is EOL.
* Better way of detecting CUDA support in pip-found TF.
* Do not output progressbars of pip in travis, the log gets too long then.
* Added support for TF 1.15.
* Update CI to test TF 1.0, 1.8, 1.14 and latest 1.x (not 2.x as before)
* Added possible problem description derived from `#9 <https://github.com/tradr-project/tensorflow_ros_cpp/issues/9>`_
* Contributors: Martin Pecka

3.1.2 (2019-08-29)
------------------
* Merge branch 'master' of git@github.com:tradr-project/tensorflow_ros_cpp.git
  # Conflicts:
  #	CHANGELOG.md
* Added support for bazel-based build with framework_shared_object=true.
* 3.1.1
* Changelog
* Contributors: Martin Pecka

3.1.1 (2019-07-17)
------------------
* Compatibility with TF 1.14.
* Updated tensorflow_catkin link, removed the rename warning.
* Contributors: Martin Pecka

3.1.0 (2018-06-25 16:55)
------------------------
* Some more informative CMake messages.
* Export tensorflow_ros_cpp_CMAKE_CXX_FLAGS_PRIVATE.
* Export tensorflow_ros_cpp_USES_CXX11_ABI which tells whether the found
  TF library uses C++11 ABI or not.
* Contributors: Martin Pecka

3.0.1 (2018-06-25 14:45)
------------------------
* Leave the tensorflow_catkin dependency in package.xml
* Added repository URLs.
* Removed dependency on swig. It should be handled upstream by tensorflow_catkin.
* Contributors: Isaac I.Y. Saito, Martin Pecka

3.0.0 (2018-06-15)
------------------
* Fixed travis badge.
* tensorflow_ros -> tensorflow_ros_cpp
* Create CHANGELOG.md
* Rename CONTRIBUTORS to CONTRIBUTORS.md
* Create CONTRIBUTORS
* Update issue templates
* Added license
* Added travis badge
* Contributors: Martin Pecka

2.1.0 (2018-06-14 11:25:04 +0200)
---------------------------------
* Added more tests.
* readme update to clarify the options to install TensorFlow.
* Implemented CI.
* Fixed installation of pip-detected TF libraries.
* Updated compatibility list.
* Contributors: Isaac I.Y. Saito, Martin Pecka

2.0.4 (2018-05-04)
------------------
* Fixed bazel TF include dir and GPU version detection
* Updated compatibility list.
* Contributors: Martin Pecka

2.0.3 (2018-05-03)
------------------
* Updated compatibility list.
* Few improvements in pip and catkin detection
* Improved bazel detection script
* Tested bazel GPU on Xenial
* Contributors: Martin Pecka

2.0.2 (2018-04-27 22:05)
------------------------
* Adjusted bazel build to GPU version
* Contributors: Martin Pecka

2.0.1 (2018-04-27 19:49)
------------------------
* Simplified searching for nsync and Eigen
* Contributors: Martin Pecka

2.0.0 (2018-04-27 17:58)
------------------------
* Polishing.
* Added Ubuntu Xenial test results.
* Final gomp fix.
* Better documentation, testing for Trusty finished.
* Fail if no search strategy succeeded.
* Added nsync as explicit include dir for tensorflow_catkin (needed in GPU build).
* Added -Wl,--no-as-needed to tensorflow-extras.cmake.in because otherwise
  it might happen that pywrap_tensorflow_internal is left out from linking
  because nothing uses its methods, but it contains some important globals.
* Fixed bazel protobuf includes.
* Added support for tensorflow_catkin.
* Fixed CUDA support detection.
* Create symlink also to the library with its original name.
* Fixed pip show output processing.
* Fallback if pip2.7 is not installed and pip2 is.
* Added a warning when different ABIs are detected.
* Fixed search for python libraries.
* Fixed symlinking the bazel library.
* Fixed Eigen dependency.
* Refactored, improved bazel-searching code.
* Refactored, much more fine-grained control over the search process.
* Contributors: Martin Pecka

1.2.1 (2017-11-21)
------------------
* Added nsync include dirs in TF 1.4
* Contributors: Martin Pecka

1.2.0 (2017-11-20)
------------------
* Added support for tensorflow 1.4
* Added support for tensorflow-gpu
* Making sure Python2 pip is called.
* Fixed support for building with catkin tools.
* Updated for tensorflow 1.1
* Removed setup.py and pointed to the now existing python-tensorflow-pip package.
* pip command fixed
* Changed the way tensorflow is searched for.
* Initial commit.
* Contributors: Martin Pecka
