# nodepp-raylib: Raylib Bindings for the Nodepp Framework

The nodepp-raylib component provides a set of high-level C++ bindings and utilities for integrating the powerful Raylib game and graphics library into the nodepp ecosystem. It enables the creation of graphical applications and games with nodepp's asynchronous and event-driven foundation.

🔗: [Your first multiplayer Games | A guide for Absolute Beginners with Raylib, Nodepp and WASM](https://medium.com/@EDBCBlog/your-first-multiplayer-games-a-guide-for-absolute-beginners-with-raylib-nodepp-and-wasm-532133942b43)

## Dependencies & Cmake Integration
```bash
include(FetchContent)

FetchContent_Declare(
	nodepp
	GIT_REPOSITORY   https://github.com/NodeppOfficial/nodepp
	GIT_TAG          origin/main
	GIT_PROGRESS     ON
)
FetchContent_MakeAvailable(nodepp)

FetchContent_Declare(
	nodepp-raylib
	GIT_REPOSITORY   https://github.com/NodeppOfficial/nodepp-raylib
	GIT_TAG          origin/main
	GIT_PROGRESS     ON
)
FetchContent_MakeAvailable(nodepp-raylib)

#[...]

target_link_libraries( #[...]
	PUBLIC nodepp nodepp-raylib #[...]
)
```

# Key Features
- Full Raylib Integration: Provides C++ wrappers and interfaces for Raylib's extensive API.
- Cross-Platform Binary Support: Uses precompiled Raylib binaries internally, eliminating the need for users to build Raylib from source.
- Asynchronous Integration: Designed to work smoothly with nodepp's event loop and coroutine system.

## Example

```cpp
#include <nodepp/nodepp.h>

namespace rl {
    #include <raylib/raylib>
}

using namespace nodepp;

void onMain() {

    rl::InitWindow(800, 450, "Nodepp Raylib Example");
    rl::SetTargetFPS(60);

    process::add( coroutine::add( COROUTINE(){
    coBegin

        while( !rl::WindowShouldClose() ){

            rl::BeginDrawing();
            
            rl::ClearBackground(rl::RAYWHITE);
            rl::DrawText("Hello from Nodepp & Raylib!", 190, 200, 20, rl::LIGHTGRAY);
            
            rl::EndDrawing();

        coNext; }
        
        rl::CloseWindow();

    coFinish
    }));
    
}
```
