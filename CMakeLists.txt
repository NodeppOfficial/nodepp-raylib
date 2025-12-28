cmake_minimum_required(VERSION 3.0.0)
project(nodepp-raylib VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Define the Interface Target FIRST
add_library(nodepp-raylib INTERFACE)

# 2. Paths
set(RAYLIB_LIB_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(NODEPP_RAYLIB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")

# 3. Determine Platform and Set Library Path
if(CMAKE_SYSTEM_NAME MATCHES "Emscripten")
    # WASM is generally architecture-independent in this context
    set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/wasm")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/linux64")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/linux32")
    endif()
elseif(MSVC)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win64_msvc")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win32_msvc")
    endif()
elseif(MINGW OR CMAKE_COMPILER_IS_GNUCC)
    # This covers Windows G++ (MinGW)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win64_mingw")
    else()
        set(RAYLIB_LIBRARY_DIR "${RAYLIB_LIB_ROOT}/win32_mingw")
    endif()
else()
    message(FATAL_ERROR "Unsupported platform or architecture for Raylib bindings.")
endif()

# 4. Find the actual library file
find_library(RAYLIB_LIBRARY 
    NAMES raylib libraylib
    HINTS "${RAYLIB_LIBRARY_DIR}"
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH
)

if(NOT RAYLIB_LIBRARY)
    message(FATAL_ERROR "Raylib not found in: ${RAYLIB_LIBRARY_DIR}")
endif()

# 5. Setup Include Directories
target_include_directories(nodepp-raylib INTERFACE "${NODEPP_RAYLIB_INCLUDE_DIR}")

# 6. Link Libraries (Order matters for MinGW/Linux)
target_link_libraries(nodepp-raylib INTERFACE 
    "${RAYLIB_LIBRARY}"
)

# 7. Add System Dependencies (The flags from your comment)
if(CMAKE_SYSTEM_NAME MATCHES "Emscripten")
    target_link_libraries(nodepp-raylib INTERFACE "${RAYLIB_LIBRARY}"
        "-sUSE_WEBGL2=1"
        "-sUSE_GLFW=3"
    )
elseif(WIN32)
    # Matches: -lws2_32 -lwinmm -lgdi32
    target_link_libraries(nodepp-raylib INTERFACE winmm ws2_32 gdi32)
elseif(APPLE)
    target_link_libraries(nodepp-raylib INTERFACE "-framework IOKit" "-framework Cocoa" "-framework OpenGL")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    # Matches: -lm and standard Linux dependencies
    target_link_libraries(nodepp-raylib INTERFACE m pthread dl rt X11)
endif()

# 8. Add Nodepp dependency if it's not already there
if (TARGET nodepp)
    target_link_libraries(nodepp-raylib INTERFACE nodepp)
endif()