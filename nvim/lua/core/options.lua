-- Line numbers (default: false)
vim.opt.number = true

-- Relative line number (default: false)
vim.o.relativenumber = true

-- Clipboard (default: '')
vim.o.clipboard = 'unnamedplus'

-- Wrap Line (display full line)
vim.o.wrap = false

-- Linebreak (default: false), no effect if wrap is false.
vim.o.linebreak = true

-- Autoindent (default: true)
vim.o.autoindent = true

-- Case sensitive search (UNLESS \C or capital in search) (default: false)
vim.o.ignorecase = true

-- Smart Case for search (default: false)
vim.o.smartcase = true

-- Spaces for indentation (default: 8)
vim.o.shiftwidth = 4

-- Number of spaces for a Tab (default: 8)
vim.o.tabstop = 4

-- Number of spaces that tab counts (default: 8)
vim.o.softtabstop = 4

-- Convert tabs to spaces (default: false)
vim.o.expandtab = true

-- Minimal number of screen lines to keep above and below the cursor (default: 0)
vim.o.scrolloff = 4 

-- Minimal number of screen columns either side of cursor if wrap is 'false' (default: 0)
vim.o.sidescrolloff = 8 

-- Highlight the current line (default: false)
vim.o.cursorline = false 

-- Force all horizontal splits to go below current window (default: false)
vim.o.splitbelow = true 

-- Force all vertical splits to go to the right of current window (default: false)
vim.o.splitright = true 

-- Set highlight on search (default: true)
vim.o.hlsearch = false 

-- Hide mode messages like -- INSERT -- (default: true)
vim.o.showmode = false 

-- Enable true colors (24-bit) (default: false)
vim.opt.termguicolors = true 

-- Which horizontal keys are allowed to travel to prev/next line (default: 'b,s')
vim.o.whichwrap = 'bs<>[]hl' 

-- Set number column width (default: 4)
vim.o.numberwidth = 4 

-- Disable creating a swap file (default: true)
vim.o.swapfile = false 

-- Enable smart indentation (default: false)
vim.o.smartindent = true 

-- Always show the tabline (default: 1)
vim.o.showtabline = 2 

-- Allow backspace over indentation, eol, and start (default: 'indent,eol,start')
vim.o.backspace = 'indent,eol,start' 

-- Pop up menu height (default: 0)
vim.o.pumheight = 10 

-- So that `` is visible in markdown files (default: 1)
vim.o.conceallevel = 0 

-- Keep signcolumn visible (Window Local) (default: 'auto')
vim.wo.signcolumn = 'yes' 

-- The encoding written to a file (default: 'utf-8')
vim.o.fileencoding = 'utf-8' 

-- Command line height (default: 1)
vim.o.cmdheight = 1 

-- Enable break indent (default: false)
vim.o.breakindent = true 

-- Decrease update time (default: 4000)
vim.o.updatetime = 250 

-- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.timeoutlen = 300 

-- Disable creating a backup file (default: false)
vim.o.backup = false 

-- Disable writebackup (default: true)
vim.o.writebackup = false 

-- Save undo history to a file (default: false)
vim.o.undofile = true 

-- Set completeopt for better completion experience (default: 'menu,preview')
vim.o.completeopt = 'menuone,noselect' 

-- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.shortmess:append 'c' 

-- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.iskeyword:append '-' 

-- Don't automatically insert the current comment leader (default: 'croql')
vim.opt.formatoptions:remove { 'c', 'r', 'o' } 

-- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles'
