cmake_minimum_required(VERSION 3.10)
project(example_1)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# --- 1. FIND VTK ---
# Since we installed VTK to /usr/local in Docker, CMake can find it automatically.
find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

# --- 2. SETUP VITA PATHS ---
# In Docker, we installed headers to /usr/local/include/vita_source
include_directories("/usr/local/include/VItA-source")

# --- 3. FIND SYSTEM LIBRARIES ---
find_package(OpenGL REQUIRED)
find_package(X11 REQUIRED)

add_executable(example_1 example_1.cpp)

# --- 4. LINK LIBRARIES ---
# libraries are in /usr/local/lib, which is a default search path.
# We no longer need the complex "brute force" linking or GLOB patterns.
target_link_libraries(example_1 
    VItA
    ${VTK_LIBRARIES}
    ${OPENGL_LIBRARIES}
    ${X11_LIBRARIES}
    ${X11_Xt_LIB}
    -lpthread
    -ldl
)

# cmake_minimum_required(VERSION 3.10)

# # set the project name
# project(example_1)

# # specify the C++ standard
# set(CMAKE_CXX_STANDARD 11)
# set(CMAKE_CXX_STANDARD_REQUIRED True)

# # Find VTK
# find_package(VTK REQUIRED HINTS "$ENV{VITA_PATH}/vita_build/lib/cmake/vtk-8.1" "/opt/vita/vita_build/lib/cmake/vtk-8.1")
# include(${VTK_USE_FILE})

# # Find VItA
# find_path(VITA_INCLUDE_DIRS core/GeneratorData.h
#           HINTS "$ENV{VITA_PATH}"
#           PATH_SUFFIXES include/vita_source)

# find_library(VITA_LIBRARY NAMES VItA
#              HINTS "$ENV{VITA_PATH}"
#              PATH_SUFFIXES lib)

# if(NOT VITA_INCLUDE_DIRS OR NOT VITA_LIBRARY)
#     message(FATAL_ERROR "VItA not found. Please set VITA_PATH environment variable.")
# endif()

# # add all include directories needed for compilation
# include_directories(${VITA_INCLUDE_DIRS} ${VTK_INCLUDE_DIRS})

# # add the executable
# add_executable(example_1 example_1.cpp)

# # link libraries
# target_link_libraries(example_1 ${VITA_LIBRARY} ${VTK_LIBRARIES})
