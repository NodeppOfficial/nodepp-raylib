export LD_LIBRARY_PATH=./lib/wasm:$LD_LIBRARY_PATH
em++ -o ./www/index.html main.cpp -I./include -L./lib/wasm -lraylib -s USE_GLFW=3 -s ASYNCIFY=1; emrun ./www