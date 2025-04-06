-- Basic settings
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.number = true          -- Show absolute line numbers vim.opt.relativenumber = true  -- Show relative line numbers vim.opt.shiftwidth = 2
vim.g.mapleader = " "
-- Toggle relative numbers in insert mode and unfocused windows
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
  callback = function()
    vim.opt.relativenumber = true
  end,
})
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
  callback = function()
    vim.opt.relativenumber = false
  end,
})
-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
-- Plugin list
local plugins = {
  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { flavour = "mocha" } },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true, -- Install parsers when entering a buffer
      })
    end,
  },
  -- neotree
  {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
  },
}
}
-- Lazy.nvim options
local opts = {
  performance = {
    rtp = {
      reset = false, -- Improve startup time by not resetting runtimepath
    },
  },
  ui = {
    border = "rounded", -- Nicer UI for Lazy.nvim
  },
}
-- Setup plugins
require("lazy").setup(plugins, opts)
-- Keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>e", ':Neotree filesystem toggle reveal left<CR>', {})
-- Colorscheme
require("catppuccin").setup() -- Already configured via opts in plugins
vim.cmd.colorscheme("catppuccin")
