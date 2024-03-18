# RikThePixel's neovim config

## Known bugs

- 

## Planned features

- WhichKey: for if other people want to use the config and see which keys are available.
- File-tree: replace netrw for a file-tree plugin that is less clunky. 
- Toggable buffer-tabs.
- Commands for switching back and forth to previous and next buffers.

## Included features

### Package manager

Using Lazy.nvim most plugins are lazy loaded by default, so no insane startup times.

### Theme

- Catppuccin
    - Applies theme to: Harpoon, Telescope, Treesitter
- Lualine

### Navigation

- Harpoon 2.0
    - Toggle file marks with `<leader>fm` in normal-mode
    - View quick-list using `<leader>fq` in normal-mode
    - Go to next or previous marks with `<leader>fn` and `<leader>fp`
    - Marked files are displayed on the status-line
    - Mark files in telescope using  `<C-f>` in insert-mode or `<leader>fm` in normal-mode
- Telescope
    - Search files `<leader>sf`
    - Search grep `<leader>sg`

### LSP and highlighting

- Syntax highlighting with Treesitter
- LSP with lspconfig-mason
    - Call the lspconfig setup function and it will automatically install required lsps
    - JavaScript and variants allow for automatic import refactoring when moving files
    - Usage:
        - `<leader>t` View signature
        - `<leader>s` View type
        - `<leader>gd` Go-to definition
        - `<leader>gr` Go-to reference
- Autocomplete using nvim-cmp

### Formatting

- Formatter.nvim `<leader>fd` (also works in visual-mode)
    - Helpers to only run certain formatters if conditions are met (Like `.prettierrc` exists)

### Git

- Conflict viewer `<leader>cq`
- Git signs