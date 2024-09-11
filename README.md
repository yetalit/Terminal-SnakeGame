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

You can compile the `key.c` code to library file using:

`gcc -shared -o libkey.so -fPIC key.c`
