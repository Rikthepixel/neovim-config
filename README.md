# RikThePixel's neovim config

## Planned features

- WhichKey: for if other people want to use the config and see which keys are available.
- File-tree: replace netrw for a file-tree plugin that is less clunky. 
- Toggable buffer-tabs.
- Commands for switching back and forth to previous and next buffers.

## Included features

### Package manager

Using Lazy.nvim most plugins are lazy loaded by default, so no insane startup times.

### Theme

A lovely theme is provided by Catppuccin together with a fancy statusline by Lualine.
The theme applies to (practically) all of the plugins used in this config (Harpoon, Lualine, Treesitter, etc.). 

### Navigation

#### File marking (harpoon.nvim 2.0)

Mark files for later (quick) usage. Marked files are displayed on the status-line with a marker and their index number.

##### Usage:
- Toggle file marks with `<leader>fm` in normal-mode
- Mark files in telescope using  `<C-f>` in insert-mode or `<leader>fm` in normal-mode
- View quick-list using `<leader>fq` in normal-mode
    - Edit the quick-list like you would and other buffer (e.g. `dd` will delete the marked file)
- Go to next or previous marks with `<leader>fn` and `<leader>fp`
- Go to marked files 1 till 10 by using `<leader>{mark_number}` (e.g. `<leader>3` for 3rd and `<leader>0` for 10th)

#### File searching (telescope.nvim)

Search through files inside of the project.

##### Usage:
- Search files `<leader>sf`
- Search grep `<leader>sg`
- Search repository `<leader>sr`

### LSP and highlighting

#### Syntax highlighting (treesitter)

Syntax highlighting with Treesitter

#### Language servers (lspconfig-mason.nvim)

Configure and use various language servers, with automatic installation. 
Call the lspconfig setup function and it will automatically install required lsps.
JavaScript and variants allow for automatic import refactoring when moving files (see tstools)

##### Usage:
- `<leader>t` View signature
- `<leader>s` View type
- `<leader>gd` Go-to definition
- `<leader>gr` Go-to reference

#### Autocomplete (nvim-cmp)

Autocomplete using nvim-cmp

### Formatting (formatter.nvim)

Format files for the specified filetypes.

#### Usage:
- Format document `<leader>fd` (also works in visual-mode)
    - Helpers to only run certain formatters if conditions are met (Like `.prettierrc` exists)

### Git

#### Git signs (gitsigns.nvim)

Changes, deletions and additions are show at the side of the buffer (in front of the line-numbers)

#### Conflicts (git-conflicts.nvim)

Open a list of git conflicts for easier conflict resolving.

##### Usage:
- Conflict viewer `<leader>cq`