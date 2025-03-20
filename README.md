# Terminal Snake Game

Terminal snake game from scratch (without third party libraries) in mojo and a bit of C.

C is used to detect user's keystrokes. The rest is in mojo.

# Game Controls

`w: Up`

`a: Left`

`s: Down`

`d: Right`

`z: Exit`

# Notes

Commands to compile the `key.c` code to library file:

Linux: `gcc -shared -o libkey.so -fPIC key.c`

MacOS: `gcc -dynamiclib -o libkey.dylib key.c`
