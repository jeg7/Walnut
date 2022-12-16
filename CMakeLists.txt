cmake_minimum_required(VERSION 3.20)

# Set the project name
project(Walnut VERSION 1.0 LANGUAGES CXX C)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

########################################################################
# For GLFW
set(GNU_COVERAGE_LINKER_FLAGS "-lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi")
#set(GNU_COVERAGE_LINKER_FLAGS "-lglfw -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi")
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${GNU_COVERAGE_LINKER_FLAGS}")
set(STATIC_LIBRARY_FLAGS "${STATIC_LIBRARY_FLAGS}  ${GNU_COVERAGE_LINKER_FLAGS}")

########################################################################
# For GLM
set(GLM_TEST_ENABLE OFF CACHE BOOL "" FORCE)
add_subdirectory(${Walnut_SOURCE_DIR}/vendor/glm)

########################################################################
# For Vulkan
find_package(Vulkan REQUIRED)

if(NOT Vulkan_FOUND)
  message(FATAL_ERROR "Vulkan::Vulkan was NOT found!")
endif()

########################################################################
# Include directories
include_directories(
  ${Walnut_SOURCE_DIR}/Walnut/src
  ${Walnut_SOURCE_DIR}/vendor/imgui
  ${Walnut_SOURCE_DIR}/vendor/stb_image
  ${Walnut_SOURCE_DIR}/vendor/glm
)

########################################################################
# CXX flags
set(CMAKE_CXX_FLAGS_DEBUG "-g -DWL_DEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
if(WL_BUILD_LINUX)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DWL_PLATFORM_LINUX")
endif()

########################################################################
# Add libraries
add_library(imgui
  ${Walnut_SOURCE_DIR}/vendor/imgui/imgui.cpp
  ${Walnut_SOURCE_DIR}/vendor/imgui/imgui_draw.cpp
  ${Walnut_SOURCE_DIR}/vendor/imgui/imgui_tables.cpp
  ${Walnut_SOURCE_DIR}/vendor/imgui/imgui_widgets.cpp
  ${Walnut_SOURCE_DIR}/vendor/imgui/imgui_demo.cpp
)

#add_library(stb_image
#  ${Walnut_SOURCE_DIR}/vendor/stb_image/stb_image.cpp
#)
add_library(Walnut INTERFACE)

add_library(WL_Walnut_Input
  ${Walnut_SOURCE_DIR}/Walnut/src/Walnut/Input/Input.cpp
)

add_library(WL_Walnut_ImGui
  ${Walnut_SOURCE_DIR}/Walnut/src/Walnut/ImGui/ImGuiBuild.cpp
)

add_library(WL_Walnut_Core
  ${Walnut_SOURCE_DIR}/Walnut/src/Walnut/Application.cpp
  ${Walnut_SOURCE_DIR}/Walnut/src/Walnut/Image.cpp
  ${Walnut_SOURCE_DIR}/Walnut/src/Walnut/Random.cpp
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
  ${Walnut_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/WalnutApp/
)

add_executable(WalnutApp.exe
  ${Walnut_SOURCE_DIR}/WalnutApp/src/WalnutApp.cpp
)

########################################################################
# Link libraries
#target_link_libraries(imgui
#  Vulkan::Vulkan
#)
#
#target_link_libraries(WL_Walnut_Core
#  glfw Vulkan::Vulkan imgui stb_image glm
#)
#
#target_link_libraries(WL_Walnut_Input
#  WL_Walnut_Core
#  glfw Vulkan::Vulkan glm
#)

target_link_libraries(Walnut INTERFACE
  WL_Walnut_Core WL_Walnut_ImGui WL_Walnut_Input
  glfw Vulkan::Vulkan imgui glm #stb_image
)

target_link_libraries(WalnutApp.exe
  Walnut
)
