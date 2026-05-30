-- Use 2 spaces when pressing tab
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Use relative line numbers for all lines
-- except the current line, which shows its absolute line number
-- known as hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
  -- add your plugins here
  
  -- catppuccin color scheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" }

  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate"

  },

}

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },

})

-- Setup telescope for fuzzy finding and live grep 
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- Setup treesitter
local treesitterlangs = { "lua", "javascript", "go" }
require('nvim-treesitter').install(treesitterlangs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitterlangs,
  callback = function()
    -- syntax highlighting, provided by nvim
    vim.treesitter.start()

    -- folds, provided by nvim
    --vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --vim.wo.foldmethod = "expr"

    -- identation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  
end,
})

-- Setup catppuccin
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

--
--
--
-- The perfect Neovim setupt for Go
-- https://www.youtube.com/watch?v=i04sSQjd-qo
--
--
-- 



