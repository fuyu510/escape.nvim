A tiny and fast Neovim plugin for a lag-free escape from insert mode using a key combination.

## ✨ Features

-   **No Delay**: Unlike traditional `inoremap jk <Esc>`, pressing the first key (`j`) is instantaneous.
-   **Configurable**: Change the key combination and timeout to your liking.
-   **Lightweight**: A single Lua file with a clear purpose.

## ⚡️ Installation

Install with your favorite plugin manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "fuyu510/escape.nvim",
  opts = {},
},
```

packer.nvim
```lua
use {
  "fuyu510/escape.nvim",
  config = function()
    require("escape").setup()
  end,
}
```

⚙️ Configuration
Call the setup function to initialize the plugin. You can override the default settings by passing a table to setup.

Default Configuration
```lua
require("escape").setup({
  key1 = 'j',
  key2 = 'k',
  timeout = 50, -- in milliseconds
})
```

Custom Configuration Example
To use f and d with a 40ms timeout:
```lua
require("escape").setup({
  key1 = 'f',
  key2 = 'd',
  timeout = 40,
})
```


