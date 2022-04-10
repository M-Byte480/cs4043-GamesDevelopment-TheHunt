# SimpleAI.newAI()

|                      | &nbsp; 
| -------------------- | ---------------------------------------------------------------
| __Type__             | [function](http://docs.coronalabs.com/api/type/Function.html)
| __Library__          | [SimpleAI.*](Readme.markdown)
| __Return value__     | Physical object
| __Keywords__         | object, AI, artificial intelligence
| __See also__         | [Documentation and code examples](http://simple-ai.blogspot.com)


## Overview

This function takes parameters and returns an object of artificial intelligence.


## Syntax

	SimpleAI.newAI( group, img, x, y )
	SimpleAI.newAI( group, img, x, y, ai_type )
	SimpleAI.newAI( group, img, x, y, ai_type, sprite )

##### group <small>(required)</small>
_[GroupObject](https://docs.coronalabs.com/api/type/GroupObject/index.html)._ The name of the group object in which need to be inserted the AI object.

##### img <small>(required)</small>
_[String](http://docs.coronalabs.com/api/type/String.html)._ The name of the image file to load, relative to `baseDir` (or `system.ResourceDirectory` by default). This will be used as an image for the object of artificial intelligence.

##### x <small>(required)</small>
_[Number](https://docs.coronalabs.com/api/type/Number.html)._ The x coordinate of the AI object.

##### y <small>(required)</small>
_[Number](https://docs.coronalabs.com/api/type/Number.html)._ The y coordinate of the AI object.

##### ai_type <small>(optional)</small>
_[String](http://docs.coronalabs.com/api/type/String.html)._ The name of the AI type, wich determines the specific behavior of AI. Available options: "patrol" (default), "guard", "boss". Default value is "patrol" if the parameter is not provided.

##### sprite <small>(optional)</small>
_[Array](https://docs.coronalabs.com/api/type/SpriteObject/index.html)._ Array with animation data ({sheet, sequences}) This is only required if you intend to create an object from a sprite object instead of static image. Default value is `{}` if the parameter is not provided.


## Examples

``````lua
local SimpleAI = require 'plugin.SimpleAI'

local enemy = SimpleAI.newAI(mainGroup, "enemy.png", 100, 300)
``````
