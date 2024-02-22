-- Leader
vim.g.mapleader = " "

-- Language
vim.api.nvim_exec("language en_US", true)

-- Indenting
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16
vim.opt.wrap = false

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Neovim Qt
vim.opt.guifont = "RobotoMono Nerd Font"

-- Bootstrap file format
vim.api.nvim_set_option("fileformats", "unix,dos,mac")

-------- 
vim.opt.laststatus = 3 -- global statusline
vim.opt.showmode = false

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true

vim.opt.fillchars = { eob = " " }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"

-- Numbers
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.ruler = false

-- disable nvim intro
vim.opt.shortmess:append "sI"

vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 100

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

