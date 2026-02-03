Instructions

The following example was created using VItA v0.2. To build the example, open a terminal in the folder containing the example's CMakeFiles.txt and use the command:

ccmake .

Press "c" to configure the compilation. Complete VItA and VTK paths. If installed VItA with DOWNLOAD_DEPENDENCIES ON, the paths should be:

VTK_INCLUDE_DIRS = <vita_folder>/vita_build/include/vtk-8.1 
VITA_INCLUDE_DIRS = <vita_folder>/include/vita_source 
VTK_LIBRARY_DIRS = <vita_folder>/vita_build/lib 
VITA_LIBRARY_DIRS = <vita_folder>/lib

Note that the tag <vita_folder> should be replaced by the folder chosen to install VItA. Further details of VItA installation are described in its readme notes (see GitHub repository https://github.com/GonzaloMaso/VItA). 
Complete the building process by pressing "c" and then "g". Then, build the example using following command in the terminal:

make

Finally, run the generated executable with the name of the example.

The output of this example should match the geometry presented in example_2.vtp and example_2.png in "output" folder.
