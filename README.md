# centrilua
Lua Centrifugo API Client
## Installiation
```bash
$ luarocks install centrilua
```
## How to use
Lua:
```lua
local centrilua = require "centrilua"

cent = centrilua(<centrifugo_url>, <centrifugo_secret>)
cent:publish(<channel>, <data>)
```
MoonScript:
```moonscript
centrilua = require "centrilua"

cent = centrilua <centrifugo_url>, <centrifugo_secret>
cent\publish <channel>, <data>
```
