Fudge
=====

An automatic texture packer for Löve2D

Feed it images and it will automagically generate a texture atlas and quads.
It can also export the generated data to reduce load times in production mode.

## Versions

The alpha version of this software was originally made during mini-LudumDare #51: "Revenge of the Tool Jam", as such the API is a little wonky and the feature set isn't very smooth. It works well, but with hindsight there are improvements to be done.   
Alpha versions are tagged "aX.Y.Z" (e.g: "a0.0.1"), they will probably never be documented, and will be moved to their own branch for retrocompatibility's sake. [Wilbefast](https://github.com/Wilbefast) and [I](https://github.com/Bradshaw) are currently using this version on several of our projects.

Versions tagged "vX.Y.Z" are designed for public consumption, will come tested and documented. They will be moved to "master" branch as they are released.

## Planned features

+ JSON/XML Exports
+ Standalone texture packer
+ More options for animation generation
+ Optional anti-texturebleed padding
