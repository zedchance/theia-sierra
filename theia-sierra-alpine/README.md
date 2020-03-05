# theia-sierra

A Docker image built off of the [theia-docker](https://github.com/theia-ide/theia-apps/tree/master/theia-docker) Dockerfile with necessary libraries for CS46 class.

Image contains: `clang`, `gdb`, `valgrind`, `libressl`.

### start.sh

This is a helper script that creates a new container, copies necessary ids over to the container, then starts it.