# tensorflow_ros

A catkin-friendly package for utilizing the C++ API of tensorflow.

## Prerequisites

This package assumes tensorflow python package is installed. Ideally via pip, but custom installs are also supported (it they're either on PYTHON\_PACKAGE\_PATH or if you manually specify environment variable TENSORFLOW\_PATH).

You also need to compile it using a more recent compiler that supports C++11. The default compiler on Ubuntu Trusty can't do that. You can install a conforming GCC 4.9 using these commands (but be aware that it can cause you some trouble with older programs in the worst case):

	sudo add-apt-repository ppa:ubuntu-toolchain-r/test
	sudo apt-get update
	sudo apt-get install g++-4.9

	sudo update-alternatives --remove-all gcc
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 20
	sudo update-alternatives --config gcc
	
This may also cause some ROS-related incompatibilities, since ROS officially doesn't support C++11. But it works well-enough for me. If you face any kind of strange linking/runtime problems, report them!

## Note

This package uses a "hack" to link against the library that's installed by pip. I have no idea if this is currently an officially supported way of accessing the C++ API, but it seems to work.