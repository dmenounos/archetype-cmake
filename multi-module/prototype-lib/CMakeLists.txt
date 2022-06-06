cmake_minimum_required(VERSION 3.8.2)

project(prototype-lib)

# Inherit common definitions and dependencies
include(../cmake/CMakeInclude.txt)

# Add all the source files to the SOURCES variable.
file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

# Add all the header files to the HEADERS variable.
file(GLOB_RECURSE HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp")

# Set the compiled file to the TARGET variable.
set(TARGET "prototype_lib")

add_library(${TARGET} SHARED ${SOURCES})

# Define the include paths that will be used by us and our clients:
# BUILD_INTERFACE will be used when this library is consumed in source form.
# INSTALL_INTERFACE will be used when this library is consumed in binary form.
target_include_directories(${TARGET} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
	$<INSTALL_INTERFACE:include/${TARGET}>
)

# Install the header files. The DESTINATION should match with the INSTALL_INTERFACE above.
install(FILES ${HEADERS} DESTINATION include/${TARGET})

# Install the compiled file. Also generate export metadata.
install(TARGETS ${TARGET} DESTINATION lib EXPORT ${TARGET}-config)

# Install the generated metadata targets file.
# Note: If we had multiple targets to export we would have to generate a config file.
# However, since we only export a single target we can use directly the targets file.
install(EXPORT ${TARGET}-config DESTINATION lib/cmake/${TARGET})
