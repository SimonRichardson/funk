# Introduction
The Funk library examples:

Examples are first split into view platforms (canvas, dom, flash, webgl, etc) and should be fairly similar to each other.

# Building

## Note: 
You will need to run ``` haxe examples.hxml ``` to pull down a patched version of xirsys_stdjs. This will be used as the extern files for the Javascript runtime. Hopefully this will be removed when haxe3 and it's new js extern files are implemented. 
This will remove any xirsys_stdjs haxelib libs you have installed.

## Run:

1. Run ``` haxe examples.hxml ```.
2. Run ``` haxe canvas-examples.hxml ``` to compile the canvas version of the examples (same for dom, swf, etc).
3. Open up the bin folder in the root directory and run the canvas/dom/swfs in the folder.

Enjoy.
