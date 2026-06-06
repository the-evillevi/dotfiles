# Neovim TODO

Manual follow-up notes for the skipped Phase 5 cleanup.

## Issues Covered

- `DOT-012`: Gradually modularize the Kickstart-derived `init.lua`.
- `DOT-013`: Review the terminal-mode escape mapping.

## Guiding Rule

Move one small piece at a time, then start Neovim and verify it still loads.
Dotfiles are easier to learn when every change has a short feedback loop.

## 2. Create A Small Config Module Structure

Start with empty Lua files:

```text
lua/config/options.lua
lua/config/keymaps.lua
lua/config/autocmds.lua
lua/plugins/init.lua
```

In `init.lua`, load them near the top after setting the leader keys:

```lua
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
```

Do not move plugin setup yet. First verify that empty modules load.

Verification:

```sh
nvim --headless '+quit'
```

## 3. Move Options First

Move basic `vim.o` and `vim.opt` settings into `lua/config/options.lua`.

Good candidates:

- `vim.g.have_nerd_font`
- line numbers
- mouse mode
- clipboard scheduling
- search behavior
- split behavior
- list characters
- cursorline
- scrolloff
- confirm

Leave plugin manager setup in `init.lua`.

Verification:

```sh
nvim --headless '+quit'
```

Learning note: options are the safest first move because they usually do not
depend on plugin load order.

## 4. Move Keymaps Second

Move general `vim.keymap.set(...)` calls into `lua/config/keymaps.lua`.

Good candidates:

- clear search highlight on `<Esc>`
- diagnostic quickfix mapping
- terminal escape mapping after you decide on it
- split navigation mappings

Leave plugin-specific keymaps inside their plugin specs for now.

Verification:

```sh
nvim --headless '+quit'
```

Then test the mappings interactively.

## 5. Move Autocommands Third

Move general autocommands into `lua/config/autocmds.lua`.

Good candidates:

- highlight on yank
- custom filetype detection for Astro

Leave LSP/plugin autocommands inside plugin configs for now.

Verification:

```sh
nvim --headless '+quit'
```

## 6. Enable A Plugin Import

Current Kickstart comments mention:

```lua
-- { import = 'custom.plugins' },
```

You can either keep using `lua/custom/plugins/` or switch to `lua/plugins/`.
Pick one style and stick to it.

Recommended simple path:

1. Keep `lua/custom/plugins/init.lua` for now.
2. Uncomment the import:

   ```lua
   { import = 'custom.plugins' },
   ```

3. Move only one optional plugin spec into `lua/custom/plugins/init.lua`.
4. Restart Neovim and run `:Lazy`.

Verification:

```sh
nvim --headless '+Lazy! sync' '+quitall'
```

Use the interactive `:Lazy` screen when you want to inspect plugin status.

## 7. Keep The Lockfile Updated

After changing plugins, update and review:

```sh
nvim
```

Inside Neovim:

```vim
:Lazy
```

If plugin versions change, review and commit:

```sh
git diff -- .config/nvim/lazy-lock.json
```

Learning note: `lazy-lock.json` is not runtime junk. It is the receipt for the
plugin versions that currently work.

## 8. Suggested Stopping Points

Safe checkpoints:

- After empty modules load.
- After moving options.
- After moving keymaps.
- After moving autocommands.
- After enabling one plugin import.

Commit at any checkpoint where Neovim starts cleanly and the diff is easy to
explain in one sentence.
