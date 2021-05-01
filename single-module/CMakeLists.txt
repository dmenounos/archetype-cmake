cmake_minimum_required(VERSION 3.8.2)

project(prototype)

set(PROJECT_VERSION 1.0)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
	message(">> CMAKE_BUILD_TYPE not specified, defaulting to ${CMAKE_BUILD_TYPE}.")
endif()

# Add all the source files to the SOURCES variable.
file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

# Set the compiled file to the TARGET variable.
set(TARGET "prototype")

add_executable(${TARGET} ${SOURCES})

target_include_directories(${TARGET} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)
