cmake_minimum_required(VERSION 3.0.0)
project(nodepp-raylib VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(NODEPP_RAYLIB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")

set(RAYLIB_LIB_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lib")

# Search for Nodepp
if (NOT TARGET nodepp)
    find_package(nodepp REQUIRED)
    if(NOT nodepp_FOUND)
        message(FATAL_ERROR "Nodepp not found. Please install nodepp.")
    endif()
endif()

# Determine Platform and Set Library Path

if(MSVC) # Windows, Microsoft Visual C++
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win64_msvc")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win32_msvc")
    endif()
elseif(MINGW OR CMAKE_COMPILER_IS_GNUCC) # Windows MinGW or General GCC
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win64_mingw")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win32_mingw")
    endif()
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/linux64")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/linux32")
    endif()
elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin") # macOS
    set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/macos")
elseif(CMAKE_SYSTEM_NAME MATCHES "Emscripten") # WebAssembly
    set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/wasm")
else()
    message(FATAL_ERROR "Unsupported platform for Raylib bindings.")
endif()

# Define the Interface Target and Link

target_include_directories(nodepp-raylib INTERFACE ${NODEPP_RAYLIB_INCLUDE_DIR})
target_link_directories(nodepp-raylib INTERFACE ${RAYLIB_LIBRARY_DIR})

# Find and link the library file
find_library(RAYLIB_LIBRARY raylib HINTS ${RAYLIB_LIBRARY_DIR})
if(NOT RAYLIB_LIBRARY)
    message(FATAL_ERROR "Raylib library file not found in: ${RAYLIB_LIBRARY_DIR}")
endif()

target_link_libraries(nodepp-raylib INTERFACE 
    nodepp 
    ${RAYLIB_LIBRARY}
    $<$<NOT:$<OR:$<BOOL:${MSVC}>,$<STREQUAL:${CMAKE_SYSTEM_NAME},Windows>>>:-lm>
)