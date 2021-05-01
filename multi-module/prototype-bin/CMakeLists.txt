cmake_minimum_required(VERSION 3.8.2)

project(prototype-bin)

# Inherit common definitions and dependencies
include(../cmake/CMakeInclude.txt)

if(NOT TARGET prototype_lib)
	find_package(prototype_lib CONFIG REQUIRED)
	message(">> Found Package: prototype_lib")
endif()

# Add all the source files to the SOURCES variable.
file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

# Set the compiled file to the TARGET variable.
set(TARGET "prototype_bin")

add_executable(${TARGET} ${SOURCES})

target_link_libraries(${TARGET} prototype_lib)

target_include_directories(${TARGET} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)
